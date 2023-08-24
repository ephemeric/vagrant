#!/usr/bin/env bash

set -ueo pipefail

arg_channel="$1"
arg_release="$2"

rm -f slob_x86_64
curl --silent --show-error -OL https://slob/downloads/$arg_channel/slob_x86_64.gz
gunzip slob_x86_64.gz
chmod 0755 slob_x86_64

# Get version from binary and remove illegal RPM name char `-`.
__slob_version="$(./slob_x86_64 --version | awk '{print$2}' | sed "s/-/_/")"

rpmbuild -bb --quiet --noprep --define "_version $__slob_version" --define "_release $arg_release" slob.spec

exit 0
