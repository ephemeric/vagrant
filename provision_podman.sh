#!/usr/bin/env bash

set -ETeuo pipefail

podman run -d \
-v $PWD/podman.sh:/vagrant/scripts/podman.sh \
-v $PWD/upload/log-generator/:/vagrant/log-generator/ \
--name loggen docker.io/library/python:3.8-slim-buster /vagrant/scripts/podman.sh
#--name loggen docker.io/library/ubuntu:latest /vagrant/scripts/podman.sh

exit 0
