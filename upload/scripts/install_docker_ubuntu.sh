#!/usr/bin/env bash

set -euo pipefail

DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install docker.io >/dev/null

exit 0

# Defunct! Do not use! Must have been for more recent version than official repo.

# install requirements
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install apt-transport-https curl lsb-release

# add docker repository signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# add the official docker repository
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# update the apt package index
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet update >/dev/null

# install docker
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install docker-ce docker-ce-cli containerd.io

# add user to docker group
gpasswd -a vagrant docker
