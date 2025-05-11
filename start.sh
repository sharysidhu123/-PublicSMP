#!/bin/bash

# Start FTP
service vsftpd start

# Run ttyd as root, but launch bash for ftpuser
ttyd -p 7681 su - ftpuser
