#!/usr/bin/env bash

# TODO: tidy this mess.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

docker run -d \
-p 8000:8000 \
-p 8089:8089 \
-p 8088:8088 \
-e "SPLUNK_START_ARGS=--accept-license" \
-e "SPLUNK_PASSWORD=changeMeVerySoon" \
-v $PWD/scripts/:/vagrant/scripts/ \
-v $PWD/log-generator/:/vagrant/log-generator/ \
-v $PWD/splunk/etc/:/opt/splunk/etc/ \
--name splunk splunk/splunk:9.0

# PIP3 install modules: pandas, geoip2 and faker.
docker exec splunk /vagrant/scripts/install_log-generator_ubuntu.sh

# Loggen: script runs /vagrant/log-generator/fortigate.py.
docker exec splunk /vagrant/scripts/provision_log-generator_fortigate.sh

if [[ $? -ne 0 ]]; then
    die "Docker exit code $?"
fi

exit 0
