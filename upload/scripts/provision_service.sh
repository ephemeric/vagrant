#!/bin/bash

if [ -n "$1" ]; then
fi

if [ -n "$2" ]; then
fi

if [ -n "$3" ]; then
fi

cat > /etc/systemd/system/slob.service << EOF
[Unit]
Description=
After=network.target
Wants=network.target

[Service]
EnvironmentFile=/etc/default/slob
Restart=on-failure
RestartSec=60
ExecStart=

[Install]
WantedBy=multi-user.target
EOF

# SELinux?

# Systemd check and reload. Use `--quiet` when package version supports it.
systemd-analyze verify slob.service
systemctl daemon-reload

exit 0
