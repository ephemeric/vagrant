#/usr/bin/env bash

echo "--------------------------------"
echo "Must be only 2 count of each IP!"
echo "--------------------------------"
# Must be only 2 count of each IP!
grep -irP ":ip|address" config/ | tr -d ',' | awk '{print $4}' | sort | uniq -c

echo "------------------------------"
echo "Must only 1 count of each MAC!"
echo "------------------------------"
# Get next available MAC. Must only 1 count of each MAC!
grep -r mac config | awk '{print $4}' | sort | uniq -c

echo "----------------------------------------------------------"
echo "For updating scripts/setup.sh which appends to /etc/hosts."
echo "----------------------------------------------------------"
# For updating scripts/setup.sh which appends to /etc/hosts.
grep -ir address config | awk -F '/' '{print $2}' | awk '{print $4 " " $1}' | tr -d '"' | tr -d ':' | tr -d '#' | sed "s/$/.ephemeric.local/" | sort

echo "----------------------"
echo "Vagrant port forwards."
echo "----------------------"
ps -ef | grep -oP "ssh -o.*\s-L\s\K(.*)"
builtin echo

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
