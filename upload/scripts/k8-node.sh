#!/bin/bash

set -euo pipefail

config_path="/vagrant/configs"

while [[ ! -f "$config_path/join.sh" ]]; do
    builtin echo "Waiting for join.sh..." >&2
    sleep 10
done

/bin/bash $config_path/join.sh -v

sudo -iu vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname)
kubectl label node $(hostname) node-role.kubernetes.io/worker=worker
EOF

exit 0
