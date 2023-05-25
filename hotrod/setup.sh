#!/bin/bash

set -euo pipefail

PROXY="$1"

if [[ "$PROXY" == "true" ]]; then

    builtin echo "Living in the country..."

cat >/etc/apt/apt.conf.d/10squid-proxy <<'EOF'
Acquire::http { Proxy "http://proxy.ephemeric.lan:3128"; };
Acquire::https { Proxy "DIRECT"; };
#Acquire::Retries 0;
EOF

mkdir -pm 0755 /etc/docker

cat >/etc/docker/daemon.json <<'EOF'
{ "insecure-registries":["registry.ephemeric.lan"] }
EOF

grep -q "ephemeric.lan" /etc/hosts || cat >>/etc/hosts <<'EOF'
192.158.122.2 registry.ephemeric.lan proxy.ephemeric.lan
EOF

else
    builtin echo "No country living."
fi

exit 0
