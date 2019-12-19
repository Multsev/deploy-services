#!/usr/bin/env bash

# Definition
ip_address=$(hostname --ip-address | cut -d" "  -f2)
zimbra='https://files.zimbra.com/downloads/8.8.11_GA/zcs-8.8.11_GA_3737.RHEL7_64.20181207111719.tgz'

# Start
yum update -y

yum install -y vim perl perl-core ntpl nmap sudo libidn gmp libaio libstdc++ unzip sysstat sqlite

echo "$ip_address $HOSTNAME" >> /etc/hosts
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

cat <<EOF >> /etc/sysctl.conf
########disable ipv6#####
net.ipv6.conf.all.disable_ipv6 = 1
EOF
sysctl -p

chkconfig sendmail off
chkconfig ip6tables off
chkconfig postfix off

-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# HTTP
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
# SMTP - Postfix
-A INPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT
# POP
-A INPUT -m state --state NEW -m tcp -p tcp --dport 110 -j ACCEPT
# IMAP
-A INPUT -m state --state NEW -m tcp -p tcp --dport 143 -j ACCEPT

# HTTPs
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
# SMTPs - Postfix
-A INPUT -m state --state NEW -m tcp -p tcp --dport 465 -j ACCEPT
# IMAPs
-A INPUT -m state --state NEW -m tcp -p tcp --dport 993 -j ACCEPT
# POP3s
-A INPUT -m state --state NEW -m tcp -p tcp --dport 995 -j ACCEPT
# LMTP
-A INPUT -m state --state NEW -m tcp -p tcp --dport 7025 -j ACCEPT
# HTTPs - Admin Console
-A INPUT -m state --state NEW -m tcp -p tcp --dport 7071 -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited

# wget -c $zimbra -O - | tar -xz
curl $zimbra | tar -xz
cd zcs*
./install.sh --platform-override --skip-activation-check --skip-upgrade-check
