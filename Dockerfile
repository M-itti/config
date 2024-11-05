# A Docker image for isolation and network testing
FROM ubuntu:latest

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Set DNS resolver to Google DNS

COPY vimrc /usr/share/vim

# Update if needed
RUN apt-get update && \
    apt-get install -y \
    curl \
    net-tools \
    iputils-ping \
    tcpdump \
    vim \
    && rm -rf /var/lib/apt/lists/*

# you can Copy your application files to the container
# Example: COPY . /app

EXPOSE 5005

VOLUME /shared

CMD resolv.conf /etc

# how to run:  
# docker build -t isolated_interface .
# sudo docker run -p 5005:5005 -v /tmp/shared:/shared isolated_interface
# docker run -p 5005:5005 -v /tmp:/shared isolated_interface --name soggy-mint
# docker exec -it soggy-mint /bin/bash

