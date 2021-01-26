#!/bin/sh

MyDBPassword=P@ssw0rd!
MyTimezone=UTC

# Add Zabbix Yum Repsitory
# See: https://www.zabbix.com/documentation/4.0/manual/installation/install_from_packages/rhel_centos
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm

yum-config-manager --enable rhel-7-server-optional-rpms

# Install Database and Zabbix
yum install --assumeyes mariadb-server zabbix-server-mysql zabbix-web-mysql zabbix-get>/dev/null

# Start Database
systemctl enable --now mariadb

# Initialize database for Zabbix
# See: https://www.zabbix.com/documentation/4.0/manual/appendix/install/db_scripts#mysql
count=`mysql --user=root --batch --skip-column-names --execute="SELECT COUNT(*) FROM mysql.user WHERE user = 'zabbix'"`
if [ "$count" -eq 0 ]; then
    echo "Creating Zabbix database ..."
    sed s/::Password::/$MyDBPassword/g /vagrant/scripts/create-database.sql | mysql -uroot
else
    echo "Zabbix database is already created."
fi

count=`mysql --user=root --batch --skip-column-names --execute="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'zabbix'"`
if [ "$count" -eq 0 ]; then
    echo "Populatiog Zabbix tables ..."
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql --user=zabbix --password=$MyDBPassword zabbix
else
    echo "Zabbix tabales are already populated."
fi

# Initial setup for web server
pushd /etc/httpd/conf.d
egrep --quiet '^\s*php_value date\.timezone\b' ./zabbix.conf 
if [ $? -ne 0 ]; then
    echo "Configuring zabbix.conf ..."
    cp --preserve ./zabbix.conf ./zabbix.conf.bak
    sed --regexp-extended "s/# (php_value date\.timezone).*/\1 $MyTimezone/" ./zabbix.conf.bak >/etc/httpd/conf.d/zabbix.conf
else
    echo "zabbix.conf is already configured."
fi
popd

# Initial setup for Zabbix server
pushd /etc/zabbix
egrep --quiet '^\s*DBPassword=' ./zabbix_server.conf 
if [ $? -ne 0 ]; then
    echo "Configuring zabbix_server.conf ..."
    cp --preserve ./zabbix_server.conf ./zabbix_server.conf.bak
    echo DBPassword=$MyDBPassword >>/etc/zabbix/zabbix_server.conf
else
    echo "zabbix_server.conf is already configured."
fi
popd

# Initial setup for Zabbix UI
pushd /etc/zabbix/web
if [ ! -f ./zabbix.conf.php ]; then
    echo "Placing zabbix.conf.php ..."
    sed s/::Password::/$MyDBPassword/g /vagrant/templates/zabbix.conf.php >./zabbix.conf.php
    chown apache:apache ./zabbix.conf.php
else
    echo "zabbix.conf.php is already placed."
fi
popd

# Start Zabbix server and UI
systemctl enable --now zabbix-server httpd
