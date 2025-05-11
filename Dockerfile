FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update && apt install -y \
    vsftpd \
    curl wget sudo git cmake g++ \
    libjson-c-dev libwebsockets-dev \
    libssl-dev libuv1-dev bash \
    net-tools iproute2 unzip xz-utils \
    && apt clean

# Set up FTP user
RUN useradd -m -s /bin/bash ftpuser && \
    echo "ftpuser:password" | chpasswd

# Configure vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# Build ttyd from source
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install && \
    cd / && rm -rf ttyd

# Add startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 21 20 8080

CMD ["/start.sh"]
