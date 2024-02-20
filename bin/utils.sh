#/usr/bin/env bash

echo "--------------------------------"
echo "Must be only 1 count of each IP!"
echo "--------------------------------"
grep -orP ":ip\s=>\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c

echo "--------------------------------"
echo "Must be only 1 count of each IP!"
echo "--------------------------------"
grep -orP "base_address\s=\s\"\d+.\d+.\d+.\d+\"" config/ | sort | uniq -c

echo "------------------------------"
echo "Must only 1 count of each MAC!"
echo "------------------------------"
# Get next available MAC. Must only 1 count of each MAC!
grep -r mac config | awk '{print $4}' | sort | uniq -c

echo "----------------------------------------------------------"
echo "For updating scripts/setup.sh which appends to /etc/hosts."
echo "----------------------------------------------------------"
# For updating scripts/setup.sh which appends to /etc/hosts.
grep -ir address config | awk -F '/' '{print $2}' | awk '{print $4 " " $1}' | tr -d '"' | tr -d ':' | tr -d '#' | sed "s/$/.ephemeric.lan/" | sort

exit 0
