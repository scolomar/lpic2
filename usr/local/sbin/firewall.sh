#!/bin/sh -x

set -e ;

localnet=127.0.0.0/8 ;
service_ports="22" ;
service_proto="tcp udp" ;
command=/sbin/iptables ;

for table in filter nat mangle raw ;
 do
  for action in --flush --zero --delete-chain ;
   do
    $command --table $table $action ;
   done ;
 done ;
 
case $1
 in
  stop)
   for x in INPUT OUTPUT FORWARD;
    do
     $command --policy $chain ACCEPT ;
     $command --append $chain --jump ACCEPT ;
    done;
   exit 0
   ;;
esac;
 
sysctl net.ipv4.ip_forward=0 ;

for chain in INPUT OUTPUT FORWARD;
 do
  $command --policy $chain DROP;
 done;

for chain in INPUT OUTPUT ;
 do
  $command --append $chain --jump ACCEPT --source $localnet --destination $localnet ;
 done;

if [ -n "$service_ports" ] ;
 then
  for proto in $service_proto ;
   do
    for port in $service_ports ;
     do
      $command --append INPUT  --jump ACCEPT --proto $proto --match $proto --dport $port ;
     done ;
   done ;
 fi ;

for proto in tcp udp ;
 do
  $command --append OUTPUT --jump ACCEPT --proto $proto ;
  $command --append INPUT  --jump ACCEPT --proto $proto --match state --state RELATED,ESTABLISHED ;
 done ;

for action in LOG DROP ;
 do
  for chain in INPUT OUTPUT FORWARD;
   do
    $command --append $chain --jump $action ;
   done ;
 done ;
