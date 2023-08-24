set -Eeu -o pipefail -o functrace; shopt -s extdebug failglob

__die() {
    builtin echo "__die: $BASH_LINENO $BASH_SOURCE $@" >&2
    exit 1
}

__stacktrace() {
    local frame=0
    while caller $frame; do
        ((frame++));
    done
}

trap __stacktrace ERR
