#!/bin/bash

set -euo pipefail

NODENAME=$(hostname -s)

__retval=0
for i in {1..5}; do
    kubeadm config images pull || __retval=1
    if [[ $__retval -ne 0 ]]; then
        builtin echo "Retrying pull..."
    else
        break
    fi
done

kubeadm init --apiserver-advertise-address=$CONTROL_IP --apiserver-cert-extra-sans=$CONTROL_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube
cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Save Configs to shared /Vagrant location
# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.

config_path="/vagrant/configs"

if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf $config_path/config
chmod 0644 $config_path/config
touch $config_path/join.sh
chmod +x $config_path/join.sh

kubeadm token create --print-join-command > $config_path/join.sh

# Install Calico Network Plugin

curl --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico.yaml -O

kubectl apply -f calico.yaml

sudo -iu vagrant bash <<EOF
mkdir -p /home/vagrant/.kube
cp -i $config_path/config /home/vagrant/.kube/
sudo chown vagrant:vagrant /home/vagrant/.kube/config
EOF

sudo -iu robertg bash <<EOF
mkdir -p /home/robertg/.kube
cp -i $config_path/config /home/robertg/.kube/
sudo chown robertg:robertg /home/robertg/.kube/config
EOF

# Install Metrics Server
kubectl apply -f https://raw.githubusercontent.com/techiescamp/kubeadm-scripts/main/manifests/metrics-server.yaml

exit 0
