#!/bin/bash
#author:luke
#mail:shorile@live.com

source /etc/profile
#PATH=/usr/local/bin:$PATH

#间隔时间，单位秒
dt=60*60
#指定间隔时间内，失败登陆次数
ts=5

#本机远程端口
port=22070

#拉黑时长
timeout=7200
#日志文件
logfile="cfadd.log"

d=$(date '+%Y-%m-%d %H:%M:%S' --date=@$(($(date +%s)-${dt})))

ips=`lastb -s "$d" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn | awk -v ts=$ts '$1>ts{print $2","$1}'`
cd `dirname $0`
if test "$ips"
then
        echo $ips | awk -v d="[$(date "+%Y-%m-%d %H:%M:%S")]" '{printf "%s",d;for(i=1;i<=NF;i++){printf " %s",$i;}print ""}' >> $logfile
        echo "$ips" | awk -v tm=$timeout -v p=$port -F "," '{print "ipset add in_tcp_dro_sidp",$1","p,"timeout",tm,"-exist"}' > lastadd.log
        echo "$ips" | awk -v tm=$timeout -v p=$port -F "," '{print "ipset add in_tcp_dro_sidp",$1","p,"timeout",tm,"-exist"}'| bash
fi
