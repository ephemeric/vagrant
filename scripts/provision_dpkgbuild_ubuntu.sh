#!/usr/bin/env bash

set -euo pipefail

cd /vagrant/dpkgbuild/

# Channel, distro release.
./build.sh "$1" "$2"

exit 0
