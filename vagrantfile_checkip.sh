#/usr/bin/env bash

grep -irP ":ip|address" config/ | tr -d ',' | awk '{print $4}' | sort | uniq -c

grep -r mac config | awk '{print $4}' | sort | uniq -c

grep -ir address config | awk -F '/' '{print $2}' | awk '{print $4 " " $1}' | tr -d '"' | tr -d ':' | tr -d '#' | sed "s/$/.hotrod.local/" | sort

sed "/slob/ s/$/ was here./" somefile

exit 0
