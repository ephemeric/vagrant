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
grep -ir address config | awk -F '/' '{print $2}' | awk '{print $4 " " $1}' | tr -d '"' | tr -d ':' | tr -d '#' | sed "s/$/.hotrod.local/" | sort

echo "-----------------"
echo "Agent ids in use."
echo "-----------------"
# Used Agent ids.
grep "hotrod agents add" scripts/provision_hotrod_server.sh | sort -k 6 | uniq

exit 0
