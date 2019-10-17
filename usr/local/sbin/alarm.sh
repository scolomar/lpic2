#!/bin/sh -x
set -e

MAILTO="root"
MAILFROM="monitor.sh"
UNIT=$1

ps_output=$( /bin/ps -ewwo vsz,user,uid,tt,start,s,ruser,ruid,rsz,psr,pri,ppid,pid,pcpu,ni,min_flt,maj_flt,cmd )
df_output=$( /bin/df )
df_i_output=$( /bin/df --inodes )
vmstat_output=$( /usr/bin/vmstat )
vmstat_s_output=$( /usr/bin/vmstat --stats )
vmstat_d_output=$( /usr/bin/vmstat --disk )
vmstat_D_output=$( /usr/bin/vmstat --disk-sum )
netstat_output=$( /bin/netstat -putana )

#/usr/bin/mail -s "Alarm for unit: $UNIT" $MAILTO <<EOF
#From:$MAILFROM
#To:$MAILTO

/bin/cat 1> alarm-log.$( date +%F_%Hh%Mm ) 0<< EOF

Alarm for unit: $UNIT

PS Output:
$ps_output

DF Output:
$df_output

DF --inodes Output:
$df_i_output

VMSTAT Output:
$vmstat_output

VMSTAT --stats Output:
$vmstat_s_output

VMSTAT --disk Output:
$vmstat_d_output

VMSTAT --disk-sum Output:
$vmstat_D_output

NETSTAT -putana Output:
$netstat_output

EOF

exit 0
