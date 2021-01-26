-- See: https://www.zabbix.com/documentation/4.0/manual/appendix/install/db_scripts#mysql

create database zabbix character set utf8 collate utf8_bin;

create user 'zabbix'@'localhost' identified by '::Password::';

grant all privileges on zabbix.* to 'zabbix'@'localhost';
