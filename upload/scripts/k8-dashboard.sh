#!/bin/bash

set -euo pipefail

config_path="/vagrant/configs"
DASHBOARD_VERSION=$(grep -E '^\s*dashboard:' /vagrant/settings.yaml | sed -E 's/[^:]+: *//')

if [ -z "${DASHBOARD_VERSION}" ]; then
    builtin echo "Dashboard version unset." >&2
    exit 1
else
    builtin echo "Dashboard version: ${DASHBOARD_VERSION}"
fi

while sudo -i -u vagrant kubectl get pods -A -l k8s-app=metrics-server | awk 'split($3, a, "/") && a[1] != a[2] { print $0; }' | grep -v "RESTARTS"; do
    echo 'Waiting for metrics server to be ready...' >&2
    sleep 5
done

sudo -iu vagrant kubectl apply -f /vagrant/k8s/kubernetes-dashboard-"${DASHBOARD_VERSION}".yaml
sudo -iu vagrant kubectl apply -f /vagrant/k8s/dashboard-adminuser.yaml
sudo -iu vagrant kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d >"${config_path}/kubernetes-dashboard-token"

while sudo -i -u vagrant kubectl get pods -A -l k8s-app=kubernetes-dashboard | awk 'split($3, a, "/") && a[1] != a[2] { print $0; }' | grep -v "RESTARTS"; do
    echo 'Waiting for kubernetes-dashboard to be ready...' >&2
    sleep 5
done

cat "${config_path}/kubernetes-dashboard-token" >&2

exit 0
