#ipset 创建ip集合
ipset create in_tcp_dro_sidp hash:net,port timeout 0

#ipset 将集合添加的iptables，黑名单规则 远端ip-本地端口
iptables -I INPUT -p tcp -m state --state NEW,ESTABLISHED -j DROP -m set --match-set in_tcp_dro_sidp src,dst

#ipset 添加到定时任务
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
crontab -l | awk '{print $0;print "*/1 * * * * bash ${SHELL_FOLDER}/commfirewall.sh"}'| crontab
