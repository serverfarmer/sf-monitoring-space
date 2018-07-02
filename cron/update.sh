#!/bin/bash
. /etc/farmconfig
. /opt/farm/scripts/functions.custom

require="12288000"  # 12GB
enough=""

dirs=`cat /etc/local/.config/space-check.directories |grep -v ^# |grep -v ^$ |sort |uniq`

for dir in $dirs; do
	space=`df -k $dir |tail -n1 |awk '{ print $4 }'`
	if [[ $space -gt $require ]]; then
		enough="$enough,space$dir"
	fi
done

if [ "$enough" != "" ]; then
	if [ -s /etc/local/.config/heartbeat.url ]; then
		url=`cat /etc/local/.config/heartbeat.url`
	else
		url=`heartbeat_url`
	fi

	report=`echo $enough |tr '/' '-'`
	curl --connect-timeout 1 --retry 2 --retry-max-time 3 -s "$url?host=$HOST&services=${report:1}" >/dev/null 2>/dev/null
fi
