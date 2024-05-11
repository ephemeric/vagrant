#!/usr/bin/env bash

set -xeuo pipefail

# TODO: tidy this mess.

# 2 days back by default as Azure HTTP data collector API doesn't accept older than 2 days.
set +u
if [[ -n "$1" ]]; then
  arg_days=$1
else
  arg_days=-2
fi

# Generate count 5000 events by default.
if [[ -n "$2" ]]; then
  arg_count=$2
else
  arg_count=5000
fi
set -u

/usr/bin/env python --version

echo $PATH

# Can also grep by `traffic_type=forward`. We are only interested in LAN => WAN egress.
/vagrant/log-generator/fortigate.py -s $(date --date="${arg_days:--2} day" '+%F') -e $(date '+%F') -c ${arg_count:-5000} -m date -o /tmp/ | grep wan | grep lan | grep -P "(sent|rcvd)byte" >/tmp/fortigate-traffic.log

exit 0
