#!/usr/bin/env bash

# All VMs.
# `config.vm.allow_hosts_modification=false` is needed (/etc/hosts untouched) but does not set hostname.
if [[ -n "$1" ]]; then
    hostnamectl set-hostname "$1"
fi

cd /vagrant/

## APT.
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet update
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install apt-transport-https ca-certificates curl jq

## Poor man's DNS. Robust, no server or mucking about with systemd-resolved.
cat >>/etc/hosts <<'EOF'
192.168.235.41 splunk.ephemeric.lan splunk
192.168.235.43 generator.ephemeric.lan generator
EOF

## Aliases.
cp scripts/profile /etc/profile.d/ephemeric.sh

## SSH keys.
cat >/home/vagrant/.ssh/id_ed25519 <<'EOF'
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDmK3y/SyVaGVfwu/S0Usulk2E+ZGJAWEk1bY43PQLa7wAAAKDD+1Gkw/tR
pAAAAAtzc2gtZWQyNTUxOQAAACDmK3y/SyVaGVfwu/S0Usulk2E+ZGJAWEk1bY43PQLa7w
AAAECGRNmwniSLGIsVBGdZcjFxd476tG3+oF34m7dQDMi58OYrfL9LJVoZV/C79LRSy6WT
YT5kYkBYSTVtjjc9AtrvAAAAHXJvYmVydGdAamFzbWluZS5lcGhlbWVyaWMubGFu
-----END OPENSSH PRIVATE KEY-----
EOF

chown vagrant:vagrant /home/vagrant/.ssh/id_ed25519
chmod 0400 /home/vagrant/.ssh/id_ed25519

cat >>/home/vagrant/.ssh/authorized_keys <<'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOYrfL9LJVoZV/C79LRSy6WTYT5kYkBYSTVtjjc9Atrv vagrant@vagrant.ephemeric.lan
EOF

## CA cert. See `provision_ca_certs.sh`.
#cp scripts/EphemericCA.crt /usr/local/share/ca-certificates/
#update-ca-certificates
# Workaround for pesky: "rehash: warning: skipping ca-certificates.crt,it does not contain exactly one certificate or CRL"
#cat scripts/EphemericCA.crt >>/etc/ssl/certs/ca-certificates.crt

## Per VM specific.
### Generator.
if [[ "$1" == "generator.ephemeric.lan" ]]; then
    # To Splunk.
    (crontab -lu vagrant 2>/dev/null || true; builtin echo '* * * * * rsync -ae "ssh -i .ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /vagrant/log-generator/destination splunk.ephemeric.lan:/vagrant/log-generator/ || true') | crontab -u vagrant -
fi

### control-node
if [[ "$1" == "cnode.ephemeric.lan" ]]; then
    # To worker nodes.
    (crontab -lu vagrant 2>/dev/null || true; builtin echo '* * * * * rsync -ae "ssh -i .ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /vagrant/configs wnode01.ephemeric.lan:/vagrant/ || true') | crontab -u vagrant -
    (crontab -lu vagrant 2>/dev/null || true; builtin echo '* * * * * rsync -ae "ssh -i .ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" /vagrant/configs wnode02.ephemeric.lan:/vagrant/ || true') | crontab -u vagrant -
fi

exit 0
