#!/bin/bash
set -e

# Start vsftpd in the background
service vsftpd start

# Run ttyd with login shell (to allow interaction)
ttyd -p 8080 --credential ftpuser:password login
