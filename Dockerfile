FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    vsftpd \
    curl \
    wget \
    sudo \
    net-tools \
    iproute2 \
    unzip \
    git \
    build-essential \
    cmake \
    pkg-config \
    libjson-c-dev \
    libwebsockets-dev \
    libssl-dev \
    libuv1-dev \
    ttyd \
    && apt clean

# Add FTP user
RUN useradd -m -s /bin/bash ftpuser && echo 'ftpuser:password' | chpasswd

# Configure vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2121 7681
CMD ["/start.sh"]
