#!/usr/bin/env bash

# PostgresPro version 9.4

# Start
timedatectl set-timezone Europe/Moscow
localectl set-locale LANG=ru_RU.utf8

yum -y update

rpm -ivh http://1c.postgrespro.ru/keys/postgrespro-1c-centos94.noarch.rpm

yum makecache
yum install -y vim postgresql-pro-1c-9.4

echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

pg_dir=$(grep postgres /etc/passwd | cut -d: -f6)

cat <<EOF >> /var/lib/pgsql/.bash_profile
export PATH=/usr/pgsql-9.4/bin:$PATH
export MANPATH=/usr/pgsql-9.4/share/man:$MANPATH
EOF

# rule on firewall (port 5432)
systemctl stop firewalld

/bin/su -s /bin/bash -c "/usr/pgsql-9.4/bin/initdb --locale=ru_RU.UTF-8 -D $pg_dir" postgres

sed -i -e "s/host all all 0.0.0.0//0 trusted/host all all 0.0.0.0//0 md5/g" /var/lib/pgsql/9.4/data/pg_hba.conf

systemctl enable postgresql-9.4 && systemctl start postgresql-9.4



# /var/lib/pgsql/9.4/data/postgresql.conf
