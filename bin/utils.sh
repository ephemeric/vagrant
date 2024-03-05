#/usr/bin/env bash

echo "--------------------------------"
echo "Vagrant: 1 count each!"
echo "--------------------------------"
grep -orP ":ip\s=>\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c

echo "--------------------------------"
echo "VMware: 1 count each!"
echo "--------------------------------"
grep -orP "base_address\s=\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c

echo "------------------------------"
echo "VMware: 1 count each!"
echo "------------------------------"
# Get next available MAC. Must only 1 count of each MAC!
grep -r mac config | awk '{print $4}' | sort | uniq -c

echo "----------------------------------------------------------"
echo "For updating scripts/setup.sh which appends to /etc/hosts."
echo "----------------------------------------------------------"
# For updating scripts/setup.sh which appends to /etc/hosts.
grep -ir address config | awk -F '/' '{print $2}' | awk '{print $4 " " $1}' | tr -d '"' | tr -d ':' | tr -d '#' | sed "s/$/.ephemeric.lan/" | sort

exit 0
