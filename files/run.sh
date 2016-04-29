#!/bin/bash

mkdir -p /data/log/mysql
mkdir -p /data/db/mysql/
mkdir -p /data/conf
mkdir -p /var/run/mysqld


if [ "${MARIADB_USERID}" != "" ]; then
	sed -i "s/mysql:x:[0-9]*:/mysql:x:${MARIADB_USERID}:/" /etc/passwd
fi

chown -R mysql: /data /var/run/mysqld

if [ ! -f /data/conf/my.cnf ]; then
    mv /etc/mysql/my.cnf  /data/conf/my.cnf
fi

ln -sf /data/conf/my.cnf /etc/mysql/my.cnf
chmod o-r /etc/mysql/my.cnf

if [ ! -f /data/db/mysql/ibdata1 ]; then

    mysql_install_db --user=mysql --datadir="/data/db/mysql"

    /usr/bin/mysqld_safe --defaults-file=/data/conf/my.cnf &
    sleep 10s

    echo "GRANT ALL ON *.* TO ${DB_USER}@'%' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;GRANT ALL ON *.* TO ${DB_USER}@'localhost' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root --password=""

    killall mysqld
    killall mysqld_safe
    sleep 10s
    killall -9 mysqld
    killall -9 mysqld_safe
fi

# mysqld_safe --user=mysql --datadir="/data/db/mysql"

supervisord --nodaemon --configuration /etc/supervisord.conf
