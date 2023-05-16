#!/bin/bash

useradd -c "Splunk User" -m -s /bin/bash -d /opt/splunk splunk

#mkdir /opt/splunk
#semanage fcontext -a -e /home /opt/splunk
#restorecon -vFR /opt/splunk

echo "alias spl='sudo -iu splunk'" >/etc/profile.d/splunk.sh

#rpm -ivh /vagrant/splunk.rpm
cd /opt && tar -xvpf splunk.tar

# Seed file is removed after use (used if etc/passwd doesn't exist).
mv /vagrant/user-seed.conf /opt/splunk/etc/system/local

sed -i "s/^SPLUNK_SERVER_NAME=.*$/SPLUNK_SERVER_NAME=splunkd/" /opt/splunk/etc/splunk-launch.conf

#export RANDFILE="/opt/splunk/.rnd"

/opt/splunk/bin/splunk --accept-license enable boot-start -systemd-managed 1 -user splunk -group splunk
# Edit splunkd.service to accept everything.

systemctl --now enable splunkd

exit 0
