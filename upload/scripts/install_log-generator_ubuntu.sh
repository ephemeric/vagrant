#!/usr/bin/env bash

set -euo pipefail

#pip3 install --proxy=http://proxy.ephemeric.lan:3128 pandas==2.0.1 pandas geoip2 faker
#pip3 install pandas geoip2 faker

apt-get -y update; apt-get -y install python3-pandas python3-geoip2 faker python3

exit 0
