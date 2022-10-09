#!/bin/bash

# copy .env that contains the versions for the ELK
cp /vagrant/.env /home/vagrant

# use "docker compose" instead of "docker-compose" to start the ELK stack
docker compose -f /vagrant/docker-compose.yml up -d

# Connect confluence container to ELK network
# elk 172.18.0.0
# confluence 10.0.0.0
docker network connect vagrant_elk confluence