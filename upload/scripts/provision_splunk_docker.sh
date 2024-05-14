#!/usr/bin/env bash

# TODO: tidy and migrate to `podman`.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

docker run -d \
-p 8000:8000 \
-p 8089:8089 \
-p 8088:8088 \
-e "SPLUNK_START_ARGS=--accept-license" \
-e "SPLUNK_PASSWORD=changeMeVerySoon" \
-v $PWD/splunk/etc/:/opt/splunk/etc/ \
--name splunk splunk/splunk:9.0

exit 0
