#!/usr/bin/env bash

# See `provision_ca_certs.sh`.

set -euo pipefail

cd /vagrant

cp scripts/EphemericCA.crt /usr/local/share/ca-certificates/

update-ca-certificates

exit 0
