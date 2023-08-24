#!/usr/bin/env bash

set -Eeuo pipefail -o functrace

vagrant destroy -f

vagrant up vagbox-out

vagrant ssh vagbox-out

exit 0
