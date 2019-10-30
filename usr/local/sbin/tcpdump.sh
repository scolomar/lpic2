#!/bin/sh -x
set -e ;
folder=/var/log/tcpdump ;
test -d $folder || mkdir --parents --verbose $folder ;
test $1 == stop && /bin/killall --verbose tcpdump && exit 0 ;
test $1 == start && /sbin/tcpdump -i any -C 10 -z gzip -w $folder/$( date +%F_%Hh%Mm ).pcap ;
for x in $( pidof tcpdump ) ; do echo -17 | tee /proc/$x/oom_adj ; done ;
for x in $( pidof sshd    ) ; do echo -17 | tee /proc/$x/oom_adj ; done ;
for x in $( pidof ncat    ) ; do echo -17 | tee /proc/$x/oom_adj ; done ;
