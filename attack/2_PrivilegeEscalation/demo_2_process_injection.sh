#!/bin/bash

# Download KK5 Process Injection Utility
cd /tmp/pe
git clone https://github.com/josh0xA/K55.git

# Build Process Injection Utility
cd K55
chmod +x build-install.sh
./build-install.sh

# Run a Sample Process (Terminal 1)
cd k55_example_process
./k55_test_process
