#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

docker run -d \
-p 3000:3000 \
--name grafana \
-v grafana:/var/lib/grafana \
-e GF_SECURITY_ADMIN_PASSWORD="changeMeSoon1234" \
grafana/grafana:11.0.0-ubuntu

exit 0
