#!/bin/sh

if grep -q /opt/farm/ext/monitoring-space/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/monitoring-space\/cron/d" /etc/crontab
fi
