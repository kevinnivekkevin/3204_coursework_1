#!/bin/bash
docker cp packetbeat.yml confluence:/packetbeat.yml
docker exec confluence /bin/sh -c "\
                                curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.4.3-amd64.deb; \
                                dpkg -i packetbeat-8.4.3-amd64.deb; \
                                cp /packetbeat.yml /etc/packetbeat/packetbeat.yml; \
                                sleep 5; \
                                service packetbeat start"