sf-monitoring-space extension extends heartbeat monitoring with disk space
monitoring ability. Directories to monitor are discovered automatically:

- mysql/postgresql working directories
- typical directories that hold lots of data

Each monitored directory, if exists and is not a symlink, is required to
have at least 12GB of free disk space on underlying filesystem.
