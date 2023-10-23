#!/bin/bash

set -Eeuo pipefail

export DEBIAN_FRONTEND="noninteractive"
__CURLOPTS="--fail --location --connect-timeout 60 --retry-connrefused --retry 10 --retry-delay 5 --retry-max-time 60 --silent --show-error"

# Modules.
cat <<EOF | tee /etc/modules-load.d/nomad.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# Sysctl.
cat <<EOF | tee /etc/sysctl.d/99-nomad.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-arptables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl -f /etc/sysctl.d/99-nomad.conf

# Repos.
curl $__CURLOPTS https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
cat <<EOF | tee /etc/apt/sources.list.d/hashicorp.list
deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main
EOF

apt-get update

# Install.
apt-get -y install nomad

curl $__CURLOPTS -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v$CNIPLUGINS_VERSION/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v$CNIPLUGINS_VERSION.tgz && mkdir -p /opt/cni/bin && tar -C /opt/cni/bin -xzf cni-plugins.tgz

# Firecracker.
export VERSION=v0.10.0
export GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64")

apt-get install -y --quiet --no-install-recommends golang-go containerd dmsetup openssh-client git binutils

for binary in ignite ignited; do
    echo "Installing ${binary}..."
    curl $__CURLOPTS -o ${binary} https://github.com/weaveworks/ignite/releases/download/${VERSION}/${binary}-${GOARCH}
    chmod 0755 ${binary}
    mv ${binary} /usr/local/bin
done

exit 0
