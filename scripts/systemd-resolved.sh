# TODO: append to line.
sed -i "s/DNS=.*/DNS=192.168.235.10:53%eth1#hotrod.local/" /etc/systemd/resolved.conf
sed -i "s/Domains=.*/Domains=~hotrod.local/" /etc/systemd/resolved.conf
sed -i "s/#DNSStubListenerExtra=.*/DNSStubListenerExtra=udp:192.168.235.10:53/" /etc/systemd/resolved.conf
systemctl restart systemd-resolved

exit 0
