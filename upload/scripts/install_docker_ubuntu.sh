#!/usr/bin/env bash

set -euo pipefail

DEBIAN_FRONTEND="noninteractive" apt-get -y install docker.io

systemctl --now enable docker

exit 0
