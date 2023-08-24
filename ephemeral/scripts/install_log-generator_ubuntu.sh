#!/usr/bin/env bash

set -euo pipefail

# Enormous deps for python3-pip! `get-pip.py` has hardly any.
DEBIAN_FRONTEND="noninteractive" apt-get -y install --quiet python3-pip python3-pandas python3-geoip2 faker >/dev/null

#pip install --proxy=http://proxy.ephemeric.lan:3128 pandas==2.0.1

exit 0
