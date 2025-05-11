#!/bin/bash

# Start FTP
service vsftpd start

# Start ttyd for ftpuser
ttyd -p 7681 -u ftpuser bash
