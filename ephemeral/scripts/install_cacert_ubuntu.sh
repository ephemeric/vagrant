#!/usr/bin/env bash

# See `provision_ca_certs.sh`.

set -euo pipefail

cd /vagrant

cp scripts/EphemericCA.crt /usr/local/share/ca-certificates/

# TODO: fix this, don't ignore stderr.
update-ca-certificates &>/dev/null

exit 0
