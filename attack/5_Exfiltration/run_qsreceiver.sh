#!/bin/bash
i=0
while :; do
  /tmp/qs/qsreceiver receive -l 10.0.0.5 -p -f /tmp/qs/data_$i.tar.gz
  ((i=i+1))
done