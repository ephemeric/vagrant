#!/usr/bin/env bash

set -euo pipefail

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

mkdir -p /vagrant/splunk/etc/apps/fortigate/samples/

# Can also grep by `traffic_type=forward`. We are only interested in LAN => WAN egress.
#/vagrant/log-generator/fortigate.py -s $(date --date="${arg_days:--2} day" '+%F') -e $(date '+%F') -c ${arg_count:-5000} -m date -o /tmp/ | grep wan | grep lan | grep -P "(sent|rcvd)byte" >/vagrant/splunk/etc/apps/fortigate/samples/fortigate-traffic.log
docker run -d --rm --name loggen -v $PWD/scripts:/vagrant/scripts -v $PWD/log-generator:/vagrant/log-generator -v $PWD/splunk/etc/apps/fortigate/samples:/vagrant/splunk/etc/apps/fortigate/samples localhost/lyftdata/loggen:0.0.1 /vagrant/scripts/provision_loggen_fortigate.sh

exit 0
