#!/bin/bash
. /etc/farmconfig
. /opt/farm/scripts/functions.custom

enough=""

check_space() {
	directory=$1
	require=$2

	if [ "$directory" != "/" ]; then
		label="$directory"
	else
		label="/rootfs"
	fi

	space=`df -k $directory |tail -n1 |awk '{ print $4 }'`
	if [[ $space -gt $require ]]; then
		enough="$enough,space$label"
	fi
}


dirs=`cat /etc/local/.config/space-check.directories |grep -v ^# |grep -v ^$ |sort |uniq`

for dir in $dirs; do
	check_space $dir 12288000  # 12GB
done

check_space /boot 81920  # 80MB
check_space / 524288  # 512MB


if [ "$enough" != "" ]; then
	if [ -s /etc/local/.config/heartbeat.url ]; then
		url=`cat /etc/local/.config/heartbeat.url`
	else
		url=`heartbeat_url`
	fi

	report=`echo $enough |tr '/' '-'`
	curl --connect-timeout 1 --retry 2 --retry-max-time 3 -s "$url?host=$HOST&services=${report:1}" >/dev/null 2>/dev/null
fi
