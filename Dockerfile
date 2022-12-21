FROM ubuntu:latest
LABEL maintainer="alphabet5"

ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  apt-get update && \
  apt-get install -y \
    bash \
    dnsutils \
    iputils-ping \
    curl \
    wget \
    net-tools \
    sudo \
    openssh-server \
    vim && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf \
	    /tmp/* \
	    /var/lib/apt/lists/* \
	    /var/tmp/*
        # arp-scan \
    # python3 \
    # python3-pip \
        # tcpdump \
# RUN \
#   python3 -m pip install cisco-documentation

# Install Kubectl
RUN if uname -m | grep 'amd64\|x86_64' > /dev/null; then curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; fi && \
    if uname -m | grep 'aarch64\|arm64' > /dev/null; then curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; fi && \
    sudo install -m 755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Flux
RUN curl -s https://fluxcd.io/install.sh | sudo bash

# Install ks
RUN if uname -m | grep 'amd64\|x86_64' > /dev/null; then curl -LO "https://github.com/alphabet5/ks/releases/download/0.0.3/ks-linux-amd64"; fi && \
    if uname -m | grep 'aarch64\|arm64' > /dev/null; then curl -LO "https://github.com/alphabet5/ks/releases/download/0.0.3/ks-linux-arm64"; fi && \
    sudo install -m 755 ks-* /usr/local/bin/ks && \
    rm ./ks-*

# Install Kubeseal
RUN if uname -m | grep 'amd64\|x86_64' > /dev/null; then wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.18.2/kubeseal-0.18.2-linux-amd64.tar.gz"; fi && \
    if uname -m | grep 'aarch64\|arm64' > /dev/null; then wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.18.2/kubeseal-0.18.2-darwin-arm64.tar.gz"; fi && \
    tar -xvzf kubeseal-* kubeseal && \
    sudo install -m 755 kubeseal /usr/local/bin/kubeseal && \
    rm kubeseal-* && \
    rm kubeseal

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm ./get_helm.sh


RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 
RUN service ssh start

RUN  echo 'test:test' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-De"]