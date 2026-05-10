#!/bin/bash

TARGET_NAME="Mi Silent Mouse"

echo "Removing any remembered Xiaomi mouse..."

blueutil --paired | grep -i "$TARGET_NAME" | while read -r line; do
    MAC=$(echo "$line" | sed 's/address: \([0-9A-Fa-f:-]*\).*/\1/' | tr '-' ':')
    echo "Unpairing $MAC"
    blueutil --unpair "$MAC"
done

echo "Searching for $TARGET_NAME ..."

while true; do
    RESULT=$(blueutil --inquiry 6 | grep -i "$TARGET_NAME")

    if [ -n "$RESULT" ]; then
        MAC=$(echo "$RESULT" \
            | sed 's/address: \([0-9A-Fa-f:-]*\).*/\1/' \
            | tr '-' ':')

        echo "Found device:"
        echo "Name: $TARGET_NAME"
        echo "MAC:  $MAC"
        echo "put your mouse at pairing mode"
        sleep 0.5
        echo "Connecting... "
        
        blueutil --connect "$MAC"

        exit 0
    fi

    echo "Not found yet… retrying."
    sleep 2
done
