#!/bin/sh
. /opt/farm/scripts/init

if [ "$HWTYPE" = "container" ] || [ "$HWTYPE" = "lxc" ]; then
	echo "skipping disk space monitoring configuration on container"
	exit 0
fi

/opt/farm/scripts/setup/extension.sh sf-db-utils
/opt/farm/ext/packages/utils/install.sh sudo

echo "discovering directories for disk space monitoring"
/opt/farm/ext/monitoring-space/discover-directories.sh >/etc/local/.config/space-check.directories

if ! grep -q /opt/farm/ext/monitoring-space/cron/update.sh /etc/crontab; then
	echo "setting up crontab entry"
	echo "*/2 * * * * root /opt/farm/ext/monitoring-space/cron/update.sh" >>/etc/crontab
fi
