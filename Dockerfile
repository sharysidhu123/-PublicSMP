FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update && apt install -y \
    vsftpd \
    curl \
    wget \
    sudo \
    net-tools \
    iproute2 \
    unzip \
    ttyd \
    && apt clean

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

# Create FTP directory
RUN mkdir -p /home/ftp && chmod 755 /home/ftp

# Create a user for FTP and ttyd
RUN useradd -m -d /home/minecraft -s /bin/bash minecraft && \
    echo "minecraft:minecraft" | chpasswd && \
    usermod -aG sudo minecraft && \
    ln -s /home/ftp /home/minecraft/ftp

# Expose FTP and ttyd ports
EXPOSE 2121 7681 40000-40010

# Launch script
CMD bash -c "\
    service vsftpd restart && \
    ttyd -p 7681 -c minecraft:minecraft bash"
