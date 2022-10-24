#!/bin/bash

# Check if privilege escalation folder exists
if [ -d "/tmp/pe" ]
then
	# Clean Up
	cd /
	rm -rf /tmp/pe
	
	# Download KK5 Process Injection Utility
	echo "whoami: $(whoami)"
	mkdir /tmp/pe
	cd /tmp/pe
	git clone https://github.com/josh0xA/K55.git
	
	# Build Process Injection Utility
	cd K55
	chmod +x build-install.sh
	./build-install.sh | echo "Building process injection utility..."
	
	# Run a Sample Process (Terminal 1)
	cd k55_example_process
	# ./k55_test_process
	echo "Patiently waiting to be attacked..."
else
	# Download KK5 Process Injection Utility
	echo "whoami: $(whoami)"
	mkdir /tmp/pe
	cd /tmp/pe
	git clone https://github.com/josh0xA/K55.git
	
	# Build Process Injection Utility
	cd K55
	chmod +x build-install.sh
	./build-install.sh | echo "Building process injection utility..."
	
	# Run a Sample Process (Terminal 1)
	cd k55_example_process
	# ./k55_test_process
	echo "Patiently waiting to be attacked..."
fi
exit 0