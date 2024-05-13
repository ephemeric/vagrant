#!/usr/bin/env bash

set -ETeuo pipefail

podman run -d \
-v $PWD/podman.sh:/vagrant/scripts/provision_loggen_podman.sh \
-v $PWD/upload/log-generator/:/vagrant/log-generator/ \
--name loggen docker.io/library/python:3.8-slim-buster /vagrant/scripts/provision_loggen_podman.sh

exit 0
