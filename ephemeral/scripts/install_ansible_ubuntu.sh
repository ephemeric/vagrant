#!/usr/bin/env bash

set -euo pipefail

DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install ansible >/dev/null

exit 0
