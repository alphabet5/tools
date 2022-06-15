FROM ubuntu:latest
LABEL maintainer="alphabet5"

RUN \
  apt update && \
  apt install -y bash dnsutils iputils-ping nmap curl wget arp-scan python3 net-tools tcpdump

CMD ["bash", "-c", "sleep 99999999999"]