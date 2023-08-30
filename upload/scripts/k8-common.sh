#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

set -Eeuo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Install CRI-O Runtime
VERSION="$(echo ${KUBERNETES_VERSION} | grep -oE '[0-9]+\.[0-9]+')"

# DNS Setting
if [ ! -d /etc/systemd/resolved.conf.d ]; then
    mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=${DNS_SERVERS}
EOF

systemctl --quiet restart systemd-resolved

swapoff -a

# keeps the swap off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

cat <<EOF | tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
# procps does not support systemd syntax!
#sysctl --system
/lib/systemd/systemd-sysctl /etc/sysctl.d/99-kubernetes-cri.conf

cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF

cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

curl --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable.gpg

curl --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable_cri-o_$VERSION.gpg

curl --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

apt-get update

apt-get -y install cri-o cri-o-runc kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"

cat >>/etc/default/crio <<EOF
${ENVIRONMENT}
EOF

local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"

cat >/etc/default/kubelet <<EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
${ENVIRONMENT}
EOF

systemctl --quiet enable crio --now

exit 0
