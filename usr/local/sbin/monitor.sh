#!/bin/sh
set -e
forks_max=900000
cpu_max=99
mem_min=1000000
blocks_min=1000000
inodes_min=100000
forks=$( vmstat -s | grep forks |awk -F' ' '{print $1}')
cpu=$(ps -e -o pcpu|sort|tail -2|head -1|cut -d. -f1|cut -d' ' -f2)
mem=$(free|grep cache:|awk '{print $4}')
blocks=$(df|grep var|awk '{print $4}')
inodes=$(df -i|grep var|awk '{print $4}')
[ $forks -gt $forks_max ]&&/usr/local/sbin/scolomar-alarm.sh FORKS
[ $cpu -gt $cpu_max ]&&/usr/local/sbin/scolomar-alarm.sh CPU
[ $mem -lt $mem_min ]&&/usr/local/sbin/scolomar-alarm.sh MEM
[ $blocks -lt $blocks_min ]&&/usr/local/sbin/scolomar-alarm.sh BLOCKS
[ $inodes -lt $inodes_min ]&&/usr/local/sbin/scolomar-alarm.sh INODES
exit 0
