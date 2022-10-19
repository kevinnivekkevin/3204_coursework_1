#!/bin/bash
i=0
while :; do
  /tmp/qsreceiver receive -l 10.0.0.5 -p -f /tmp/data_$i.tar.gz
  ((i=i+1))
done
