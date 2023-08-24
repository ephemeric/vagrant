#!/usr/bin/env bash

set -euo pipefail

cd /vagrant/rpmbuild/

# Channel, distro release.
./build.sh "$1" "$2"

exit 0
