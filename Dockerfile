FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT=/usr/lib/go
ENV GOPATH=/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

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
    golang \
    util-linux \
    && apt clean

# Create user
RUN useradd -m -s /bin/bash ftpuser && echo 'ftpuser:password' | chpasswd

# Configure vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# Manually build Gotty
RUN git clone https://github.com/yudai/gotty.git /tmp/gotty && \
    cd /tmp/gotty && \
    go build -o /usr/local/bin/gotty

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2121 8080
CMD ["/start.sh"]
