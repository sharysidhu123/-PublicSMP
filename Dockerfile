#!/bin/bash

set -e

# Install vsftpd
sudo apt update && sudo apt install -y vsftpd

# Backup config
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Write a minimal, container-friendly config
sudo bash -c 'cat > /etc/vsftpd.conf' <<EOF
listen=YES
listen_port=2121
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
allow_writeable_chroot=YES
seccomp_sandbox=NO
pasv_enable=NO
connect_from_port_20=NO
EOF

# Add a test user
FTP_USER="ftpuser"
FTP_PASS="ftp123"
FTP_HOME="/home/$FTP_USER"

sudo useradd -m -d "$FTP_HOME" -s /bin/bash "$FTP_USER"
echo "$FTP_USER:$FTP_PASS" | sudo chpasswd

# Ensure correct permissions
sudo chown "$FTP_USER:$FTP_USER" "$FTP_HOME"

# Restart FTP server
sudo service vsftpd restart

# Output
echo "✅ FTP setup complete!"
echo "➡️  Connect via: ftp 127.0.0.1 2121"
echo "👤 Login: $FTP_USER / $FTP_PASS"
