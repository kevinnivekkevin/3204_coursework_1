#!/bin/bash
docker network connect --ip 10.0.0.2 network_3204 postgres
docker network connect --ip 10.0.0.3 network_3204 confluence
docker container restart postgres
docker container restart confluence