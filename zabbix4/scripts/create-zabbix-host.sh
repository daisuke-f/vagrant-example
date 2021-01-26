#!/bin/sh

Server=$1
Hostname=$2
IPAddr=$3

# Linux servers
GroupId=2

# Template OS Linux
TemplateId=10001

call_zabbix_api() {
    method=$1
    params=$2

    seq=`expr $seq + 1`

    request='{"jsonrpc":"2.0","method":"'$method'","id":'$seq',"auth":'$auth',"params":'$params'}'

    curl --silent --header 'Content-Type: application/json-rpc' --data $request http://$Server/zabbix/api_jsonrpc.php
}

seq=0
auth=null

# Login
resp=`call_zabbix_api user.login '{"user":"Admin","password":"zabbix"}'`

if [ $? -ne 0 ]; then
    exit
fi

if (echo $resp | grep --quiet "error"); then
    echo Error: $resp >&2
    exit
fi

auth=`echo $resp | grep --perl-regexp --only-matching '(?<="result":)"[^"]+"'`

# Get Host
resp=`call_zabbix_api host.get '{"filter":{"host":["'$Hostname'"]},"countOutput":true}'`

if [ $? -ne 0 ]; then
    exit
fi

if (echo $resp | grep --quiet "error"); then
    echo Error: $resp >&2
    exit
fi

if (echo $resp | grep --quiet '"result":"1"'); then
    echo Host $Hostname is already exists.
else
    # Create Host
    resp=`call_zabbix_api host.create '{"host":"'$Hostname'","interfaces":{"type":1,"main":1,"useip":1,"ip":"'$IPAddr'","dns":"","port":"10050"},"groups":{"groupid":"'$GroupId'"},"templates":{"templateid":"'$TemplateId'"}}'`

    if (echo $resp | grep --quiet "error"); then
        echo Error: $resp >&2
    fi
fi

# Log out
call_zabbix_api user.logout [] >/dev/null
