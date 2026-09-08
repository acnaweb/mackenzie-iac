FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    unzip \
    gnupg \
    build-essential \
    git \
    openssh-client \
    iputils-ping \
    groff \
    nano \
    ca-certificates \
    telnet && \
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*

# Instalar Terraform    
RUN wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Instalar AWS CLI
RUN curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash

# Instalar GCP gcloud CLI
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN apt update && apt install terraform google-cloud-cli

WORKDIR /shared

# Comando padrão ao rodar o contêiner
CMD ["/bin/bash"]