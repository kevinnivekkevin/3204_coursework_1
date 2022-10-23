#!/bin/bash

# Start Confluence
/etc/init.d/confluence start

# General
apt-get update
apt-get install rsyslog dnsutils gcc libpcap0.8 git make g++ python3-distutils python3-setuptools python3-venv -y
wget --no-check-certificate https://bootstrap.pypa.io/pip/3.6/get-pip.py -O /tmp/get-pip.py
python3 /tmp/get-pip.py
service rsyslog start

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

# Setup auditbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.3.3-amd64.deb
dpkg -i auditbeat-8.3.3-amd64.deb
cp /vagrant/config/auditbeat/auditbeat.yml /etc/auditbeat/auditbeat.yml

#[PRIVILEGE ESCALATION]

# Uninstall Existing sudo
export SUDO_FORCE_REMOVE=yes
apt-get purge sudo -y

# Download sudo 1.8.27
cd /tmp
wget http://www.sudo.ws/dist/sudo-1.8.27.tar.gz
tar -xf sudo-1.8.27.tar.gz

# Install sudo 1.8.27
cd sudo-1.8.27
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.27 \
            --with-passprompt="[sudo] password for %p: " && make
make install && ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0

# Start beats
echo "Waiting for Kibana to be up, sleeping for 60s..."
sleep 60
filebeat setup -e
packetbeat setup -e
auditbeat setup -e
service filebeat start
service packetbeat start
service auditbeat start