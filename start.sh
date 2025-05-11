#!/bin/bash
set -e

# Start FTP server in background
service vsftpd start

# Start ttyd on port 8080
ttyd -p 8080 bash
