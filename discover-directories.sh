#!/bin/sh
. /opt/farm/ext/db-utils/functions.mysql

user=`mysql_local_user`

if [ "$user" != "" ]; then
	pass=`mysql_local_password`
	echo "# mysql-server data directory"
	echo 'show variables where variable_name like "datadir"' |mysql -u $user -p$pass 2>/dev/null |grep ^datadir |awk '{ print $2 }'
	echo
fi

if [ -x /usr/bin/psql ]; then
	cd /tmp
	echo "# postgresql data directory"
	echo 'show data_directory' |sudo -u postgres psql 2>/dev/null |grep -A1 -- '--------' |tail -n1 |sed s/\ //g
	echo
fi

echo "# non-empty generic data directories"
for dir in `cat /opt/farm/ext/monitoring-space/config/directories.conf |grep -v ^#`; do
	if [ -d $dir ] && [ ! -h $dir ] && [ "`ls -A $dir`" != "" ]; then
		echo $dir
	fi
done
