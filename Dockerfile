FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

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
    golang-go \
    util-linux \
    && apt clean

# Create user
RUN useradd -m -s /bin/bash ftpuser && echo 'ftpuser:password' | chpasswd

# Configure vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# Install Gotty
RUN go install github.com/yudai/gotty@latest && \
    cp /root/go/bin/gotty /usr/local/bin/gotty

# Start services
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2121 8080
CMD ["/start.sh"]
