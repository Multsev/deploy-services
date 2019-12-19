#!/usr/bin/env bash

# Definition
path_1c_dir='/mnt/1c_dist/'

# Start
timedatectl set-timezone Europe/Moscow
localectl set-locale LANG=ru_RU.utf8

yum -y update
# Install EPEL and other packeges
yum install -y epel-release vim policycoreutils-python wget bzip2 ntp net-tools \
  unixODBC ImageMagick ImageMagick.i686 fontconfig-devel p11-kit-trust.i686 chrony

# Install mscorefonts
wget http://li.nux.ro/download/nux/dextop/el7/x86_64/msttcore-fonts-installer-2.6-1.noarch.rpm
yum install msttcore-fonts-installer-2.6-1.noarch.rpm

sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#echo "$hostname " >> /etc/hosts

yum localinstall -y $path_1c_dir"*.rpm"

systemctl start chronyd && systemctl enable chronyd
#systemctl start srv1cv83 & systemctl enable srv1cv83
chkconfig srv1cv83 on && /etc/init.d/srv1cv83 start
