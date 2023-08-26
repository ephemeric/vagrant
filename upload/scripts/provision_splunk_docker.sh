#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

docker run -d -p 8000:8000 -p 8089:8089 -p 8088:8088 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=changeMeVerySoon" -v $PWD/splunk/etc/:/opt/splunk/etc/ -v $PWD/log-generator/destination:/vagrant/log-generator/destination --name splunk splunk/splunk:9.0

if [[ $? -ne 0 ]]; then
    die "Docker exit code $?"
fi

exit 0
