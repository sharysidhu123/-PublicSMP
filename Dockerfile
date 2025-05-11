FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt update && apt install -y \
    vsftpd \
    curl \
    wget \
    sudo \
    net-tools \
    iproute2 \
    unzip \
    libjson-c-dev \
    libwebsockets16 \
    libssl1.1 \
    libuv1 \
    xz-utils \
    && apt clean

# Create a user for terminal and FTP access
RUN useradd -m -d /home/minecraft -s /bin/bash minecraft && \
    echo "minecraft:minecraft" | chpasswd && \
    usermod -aG sudo minecraft

# Download and install ttyd manually
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

# Create FTP directory and symlink
RUN mkdir -p /home/ftp && chmod 755 /home/ftp && \
    ln -s /home/ftp /home/minecraft/ftp

# Expose FTP and ttyd ports
EXPOSE 2121 7681 40000-40010

# Run both services
CMD bash -c "vsftpd & ttyd -p 7681 -c minecraft:minecraft bash"
