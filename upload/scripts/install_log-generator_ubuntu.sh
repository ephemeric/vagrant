#!/usr/bin/env bash

set -euo pipefail

DEBIAN_FRONTEND="noninteractive" apt-get -y install python3-pandas python3-geoip2 faker

exit 0
