#!/usr/bin/env bash

set -euo pipefail

DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install docker.io

exit 0

DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install apt-transport-https curl lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet update
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install docker-ce docker-ce-cli containerd.io

usermod -aG docker vagrant

exit 0

#curl -fsSL https://get.docker.com -o get-docker.sh
# sudo apt-get update
# sudo apt-get install ca-certificates curl gnupg
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg
#
# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#     "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#       sudo apt-get update
