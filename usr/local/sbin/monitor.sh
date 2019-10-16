#!/bin/sh -x
set -e

forks_max=900000
pcpu_max=99
mem_min=100000
blocks_min=1000000
inodes_min=100000

# Google cloud shell
forks=$( vmstat --forks | awk ' { print $1 } ' )
pcpu=$( ps -e -o pcpu | sort | tail -n 2 | head -n 1 | awk ' { print $1 } ' )
mem=$( free | awk ' /Mem/{ print $7 } ' )
blocks=$( df | awk ' /home/{ print $4 } ' )
inodes=$( df --inodes | awk ' /home/{ print $4 } ' )

[ $forks -gt $forks_max ]   && /usr/local/sbin/alarm.sh FORKS
[ $pcpu -gt $pcpu_max ]     && /usr/local/sbin/alarm.sh CPU
[ $mem -lt $mem_min ]       && /usr/local/sbin/alarm.sh MEM
[ $blocks -lt $blocks_min ] && /usr/local/sbin/alarm.sh BLOCKS
[ $inodes -lt $inodes_min ] && /usr/local/sbin/alarm.sh INODES

exit 0
