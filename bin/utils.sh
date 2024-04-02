#/usr/bin/env bash

set -ETeuo pipefail

echo "# Vagrant IPs"
grep -orP ":ip\s=>\s\"\d+.\d+.\d+.\d+\"" config/ | sort -k 3
builtin echo

echo "Vagrant IPs in conflict!"
if ! grep -orP ":ip\s=>\s\"\d+.\d+.\d+.\d+\"" config/ | awk '{print $3}' | sort | uniq -c | grep -vP "^\s+1"; then
    builtin echo -e "None.\n"
fi

echo "# VMware IPs"
grep -orP "base_address\s=\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c
builtin echo

echo "# VMware IPs in conflict!"
if ! grep -orP "base_address\s=\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c | grep -vP "^\s+1"; then
    builtin echo -e "None.\n"
fi

# Get next available MAC.
echo "# VMware MACs"
grep -r mac config | tr -d " "
builtin echo

echo "# VMware MACs in conflict!"
if ! grep -r mac config | awk '{print $4}' | sort | uniq -c | grep -vP "^\s+1"; then
    builtin echo -e "None.\n"
fi

exit 0
