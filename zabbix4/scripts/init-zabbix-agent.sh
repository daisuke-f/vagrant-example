#!/bin/sh

Hostname=$1
Server=$2

echo "Hostname=$Hostname"
echo "Server=$Server"

# Add Zabbix Yum Repsitory
rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm

# Install Zabbix agent
yum install --assumeyes zabbix-agent >/dev/null

# Configure
echo "Configuring zabbix_agentd.conf ..."
pushd /etc/zabbix
cp --preserve ./zabbix_agentd.conf ./zabbix_agentd.conf.bak
(
    cat ./zabbix_agentd.conf.bak |
    sed --regexp-extended "s/^\s*(Hostname=).*/\1$Hostname/" |
    sed --regexp-extended "s/^\s*(Server=).*/\1$Server/" |
    sed --regexp-extended "s/^\s*(ServerActive=).*/\1$Server/"
) >./zabbix_agentd.conf
popd

# Start Zabbix agent
systemctl enable --now zabbix-agent
