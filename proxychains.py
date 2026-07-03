#!/usr/bin/env python3
"""
proxychains4 wrapper with built-in monitoring

Wraps the real `proxychains4` binary. By default, every invocation:
  1. Opens a new (detached) tmux window running an mitmproxy SOCKS5 listener,
     without switching focus away from the current tmux window.
  2. Rewrites the proxychains config so the mitm listener is the last hop
     in the chain (mitm terminates the SOCKS5 connection and connects
     directly to the target).
  3. Execs the real proxychains4 binary against the target app, using the
     rewritten config.

Install this as `proxychains4` earlier in $PATH than the real binary
(e.g. ~/.local/bin/proxychains4), or invoke it under a different name
and alias it yourself.

Usage:
  proxychains4 myapp arg1 arg2          # monitored (default)
  proxychains4 --no-monitor myapp ...   # plain passthrough, no mitm/tmux
"""

import argparse
import os
import shutil
import socket
import subprocess
import sys
import tempfile
from pathlib import Path

DEFAULT_PROXYCHAINS_CONF_CANDIDATES = [
    Path("/usr/local/etc/proxychains.conf"),
    Path.home() / ".proxychains" / "proxychains.conf",
    Path("/etc/proxychains4.conf"),
    Path("/etc/proxychains.conf"),
]

TMUX_WINDOW_NAME = "mitm-monitor"


def find_real_proxychains4() -> str:
    """Find proxychains4 on PATH, skipping this script's own directory."""
    self_path = Path(sys.argv[0]).resolve()
    self_dir = str(self_path.parent)

    path_dirs = [d for d in os.environ.get("PATH", "").split(os.pathsep) if d]
    for d in path_dirs:
        if os.path.abspath(d) == os.path.abspath(self_dir):
            continue
        candidate = Path(d) / "proxychains4"
        if candidate.is_file() and os.access(candidate, os.X_OK):
            if candidate.resolve() != self_path:
                return str(candidate)

    # Fallback: shutil.which, then hard error
    found = shutil.which("proxychains4")
    if found and Path(found).resolve() != self_path:
        return found

    sys.exit(
        "Could not find the real proxychains4 binary on $PATH "
        "(only found this wrapper). Is proxychains4 installed?"
    )


def find_free_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("127.0.0.1", 0))
        return s.getsockname()[1]


def find_base_config() -> Path:
    for candidate in DEFAULT_PROXYCHAINS_CONF_CANDIDATES:
        if candidate.is_file():
            return candidate
    sys.exit(
        "No proxychains config found. Checked: "
        + ", ".join(str(c) for c in DEFAULT_PROXYCHAINS_CONF_CANDIDATES)
    )


def build_monitored_config(base_conf: Path, mitm_port: int) -> Path:
    """
    Read the user's existing proxychains config, strip any existing
    [ProxyList] entries, and replace them with a single hop pointing at
    our local mitmproxy SOCKS5 listener. Everything above [ProxyList]
    (chain type, timeouts, etc.) is preserved as-is.
    """
    lines = base_conf.read_text().splitlines()

    header_lines = []
    in_proxylist = False
    for line in lines:
        stripped = line.strip()
        if stripped.lower() == "[proxylist]":
            in_proxylist = True
            header_lines.append(line)
            continue
        if in_proxylist:
            # skip existing proxy entries; we replace them
            continue
        header_lines.append(line)

    if not in_proxylist:
        # config had no [ProxyList] section (unusual) — add one
        header_lines.append("[ProxyList]")

    header_lines.append(f"socks5 127.0.0.1 {mitm_port}")

    tmp = tempfile.NamedTemporaryFile(
        mode="w", suffix=".conf", prefix="proxychains-monitor-", delete=False
    )
    tmp.write("\n".join(header_lines) + "\n")
    tmp.close()
    return Path(tmp.name)


def in_tmux() -> bool:
    return "TMUX" in os.environ


def launch_mitm_window(mitm_port: int) -> None:
    """
    Open a new detached tmux window running mitmproxy in SOCKS5 mode,
    without switching the user's focus to it.
    """
    mitm_cmd = (
        f"mitmproxy --mode socks5 "
        f"--listen-host 127.0.0.1 --listen-port {mitm_port}"
    )

    if in_tmux():
        # -d: create window but do not switch to it
        subprocess.run(
            ["tmux", "new-window", "-d", "-n", TMUX_WINDOW_NAME, mitm_cmd],
            check=True,
        )
    else:
        # Not inside tmux at all — start (or reuse) a session in the
        # background so we still don't hijack the caller's terminal.
        session = "proxychains-monitor"
        exists = subprocess.run(
            ["tmux", "has-session", "-t", session],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if exists.returncode != 0:
            subprocess.run(
                ["tmux", "new-session", "-d", "-s", session,
                 "-n", TMUX_WINDOW_NAME, mitm_cmd],
                check=True,
            )
        else:
            subprocess.run(
                ["tmux", "new-window", "-d", "-t", session,
                 "-n", TMUX_WINDOW_NAME, mitm_cmd],
                check=True,
            )
        print(
            f"(not inside tmux — mitm running in background session "
            f"'{session}', window '{TMUX_WINDOW_NAME}'; "
            f"attach with: tmux attach -t {session})",
            file=sys.stderr,
        )


def wait_for_port(port: int, timeout: float = 5.0) -> None:
    import time
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(("127.0.0.1", port)) == 0:
                return
        time.sleep(0.1)
    sys.exit(f"mitmproxy did not come up on port {port} within {timeout}s")


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="proxychains4",
        add_help=False,  # let the real binary handle its own -h/--help
    )
    parser.add_argument("--no-monitor", dest="monitor",
                         action="store_false", default=True,
                         help="disable mitm monitoring, plain passthrough")
    parser.add_argument("-f", dest="config", default=None,
                         help="proxychains config file (passthrough)")
    args, rest = parser.parse_known_args()

    if not rest:
        sys.exit("Usage: proxychains4 [--no-monitor] [-f config] <app> [args...]")

    real_bin = find_real_proxychains4()

    if not args.monitor:
        # --no-monitor: plain passthrough
        cmd = [real_bin, "-q"]
        if args.config:
            cmd += ["-f", args.config]
        cmd += rest
        os.execv(real_bin, cmd)  # replace this process entirely
        return

    base_conf = Path(args.config) if args.config else find_base_config()
    mitm_port = find_free_port()

    launch_mitm_window(mitm_port)
    wait_for_port(mitm_port)

    monitored_conf = build_monitored_config(base_conf, mitm_port)

    cmd = [real_bin, "-q", "-f", str(monitored_conf)] + rest

    os.execv(real_bin, cmd)


if __name__ == "__main__":
    main()
