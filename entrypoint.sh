#!/bin/bash
set -e

echo "user:$($SSH_PASSWORD)" | chpasswd
exec /usr/sbin/sshd -D