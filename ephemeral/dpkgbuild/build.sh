#!/usr/bin/env bash

set -ueo pipefail

export DEBEMAIL="Vagrant User <vagrant@ephemeric.lan>"

arg_channel="$1"
arg_release="$2"

# See rpmbuild.

# Get version from binary.
__slob_version="$(./slob --version | awk '{print$2}')"

# Interactive. Updates debian/changelog.
#dch --increment --distribution jammy
# Noninteractive. Updates debian/changelog.
#dch -v "${__slob_version}ubuntu1" -D "jammy" "Latest dev once more."
dch -b -v "${__slob_version}$arg_release" -D "UNRELEASED" "Vagrant automated build."

# Looks for version in debian/changelog, hence the above `dch`, see `man debchange`.
debuild -i -us -uc -b >/dev/null

exit 0
