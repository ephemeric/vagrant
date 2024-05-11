#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

apt-get -y update; apt-get -y install python3-pandas python3-geoip2 faker python3

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

# Can also grep by `traffic_type=forward`. We are only interested in LAN => WAN egress.
/vagrant/log-generator/fortigate.py -s $(date --date="${arg_days:--2} day" '+%F') -e $(date '+%F') -c ${arg_count:-5000} -m date -o /tmp/ | grep wan | grep lan | grep -P "(sent|rcvd)byte" >/tmp/fortigate-traffic.log

exit 0
