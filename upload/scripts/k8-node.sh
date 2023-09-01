#!/bin/bash
#
# Setup for Node servers

set -euo pipefail

config_path="/vagrant/configs"

while [[ ! -f "$config_path/join.sh" ]]; do
    builtin echo "Waiting for join.sh..." >&2
    sleep 10
done

#while [[ ! -f "$config_path/config" ]]; do
#    builtin echo "Waiting for config..." >&2
#    sleep 5
#done

/bin/bash $config_path/join.sh -v

sudo -iu vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF