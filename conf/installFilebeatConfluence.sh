#!/bin/bash
docker exec confluence /bin/sh -c "apt-get update -y;apt-get install iputils-ping -y;apt-get install net-tools -y;apt-get install nano -y;apt-get install curl -y;apt-get install ca-certificates -y;curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.17.2-amd64.deb;dpkg -i filebeat-7.17.2-amd64.deb;curl -L https://gist.githubusercontent.com/kevinnivekkevin/03579a85da2f9b31d24462a2204bd652/raw/455dd7c5f57cc8ef19d67d5f4f3f720ab68ef30a/filebeat.yml -o /etc/filebeat/filebeat.yml;sleep 5;service filebeat start"