#!/usr/bin/env bash

set -ETeuo pipefail

podman run -d \
-v $PWD/upload/scripts/:/vagrant/scripts/ \
-v $PWD/upload/log-generator/:/vagrant/log-generator/ \
--name loggen docker.io/library/ubuntu:latest /vagrant/scripts/podman.sh

exit 0
