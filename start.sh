#!/bin/bash
set -e

# Start FTP server
service vsftpd start

# Launch Gotty on port 8080 with shell for ftpuser
gotty -w -p 8080 --credential ftpuser:password --reconnect /bin/login
