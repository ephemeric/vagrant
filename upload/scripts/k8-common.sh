#!/bin/bash

set -Eeuo pipefail

export DEBIAN_FRONTEND="noninteractive"
__CURLOPTS="--fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error"

# Swap.
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

cat <<EOF | tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# Sysctl.
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl -f /etc/sysctl.d/99-kubernetes-cri.conf

# Repos.
curl $__CURLOPTS https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable.gpg
cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb [signed-by=/etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF

curl $__CURLOPTS https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$KUBERNETES_VERSION/$OS/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable_cri-o_$KUBERNETES_VERSION.gpg
cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$KUBERNETES_VERSION.list
deb [signed-by=/etc/apt/trusted.gpg.d/devel_kubic_libcontainers_stable_cri-o_$KUBERNETES_VERSION.gpg] http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$KUBERNETES_VERSION/$OS/ /
EOF

curl $__CURLOPTS https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg
cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /
EOF

apt-get update

# Install.
#apt-get -y install cri-o cri-o-runc kubelet="$PKG_KUBERNETES_VERSION" kubectl="$PKG_KUBERNETES_VERSION" kubeadm="$PKG_KUBERNETES_VERSION"
apt-get -y install cri-o cri-o-runc kubelet kubectl kubeadm

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
