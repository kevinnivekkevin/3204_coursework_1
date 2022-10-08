#!/bin/bash
docker container stop confluence
cp confluence.cfg.xml confluence-home/confluence.cfg.xml
docker container start confluence