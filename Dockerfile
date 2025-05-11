FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Set a default hostname
ENV HOSTNAME=minecraft-server

# Base packages
RUN apt update && apt install -y \
    curl \
    wget \
    sudo \
    net-tools \
    iproute2 \
    unzip \
    xz-utils \
    ca-certificates && \
    apt clean

# Set hostname manually
RUN echo "$HOSTNAME" > /etc/hostname && \
    echo "127.0.1.1 $HOSTNAME" >> /etc/hosts

# Install vsftpd
RUN apt install -y vsftpd

# Add minecraft user
RUN useradd -m -d /home/minecraft -s /bin/bash minecraft && \
    echo "minecraft:minecraft" | chpasswd && \
    usermod -aG sudo minecraft

# Manually install ttyd dependencies
RUN mkdir -p /tmp/libs && cd /tmp/libs && \
    wget http://archive.ubuntu.com/ubuntu/pool/universe/libj/libjson-c/libjson-c4_0.13.1+dfsg-7ubuntu1_amd64.deb && \
    wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/universe/libu/libuv1/libuv1_1.34.2-1ubuntu1_amd64.deb && \
    dpkg -i *.deb || apt-get install -fy && rm -rf /tmp/libs

# Install ttyd
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -O /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

# Configure vsftpd
RUN bash -c "cat > /etc/vsftpd.conf" <<EOF
listen=YES
listen_port=2121
anonymous_enable=YES
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40010
EOF

# Setup FTP directory
RUN mkdir -p /home/ftp && chmod 755 /home/ftp && \
    ln -s /home/ftp /home/minecraft/ftp

# Expose ports
EXPOSE 2121 7681 40000-40010

# Start services
CMD bash -c "vsftpd & ttyd -p 7681 -c minecraft:minecraft bash"
