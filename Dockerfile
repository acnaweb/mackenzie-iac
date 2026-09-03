FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    unzip \
    gnupg \
    build-essential \
    git \
    openssh-client \
    iputils-ping \
    groff \
    nano \
    telnet && \
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*




