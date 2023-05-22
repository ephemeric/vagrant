#!/usr/bin/env bash

set -xeuo pipefail

# TODO: determine OS... do relevent tasks.
sudo apt-get -y install rsync
#sudo dnf -y install rsync

# Portable for Rocky, Ubuntu, et al.
getent passwd datacourier || sudo useradd -c 'Data Courier,,,,UMASK=077' -m -s /bin/bash datacourier

## Destination.
#ssh-keyscan -t ed25519 ops0.hotrod.app | ssh-keygen -lf -
#
#Host dest
#    HostName dest
#
#Host *
#    ServerAliveInterval 15
#    ServerAliveCountMax 3
#    TCPKeepAlive no
#    ExitOnForwardFailure yes
#    VisualHostKey no
#    ForwardAgent no
#    AddKeysToAgent no
#    IdentitiesOnly yes
#    PubkeyAuthentication yes
#    IdentityFile ~/.ssh/id_ed25519
#
# crontab: rsync -ave ssh ops0.hotrod.app:data.tgz .

## Source.
sudo -iu datacourier mkdir -p -m 0700 .ssh
sudo bash -c 'echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEqTzR6nOrkPvAArw2Qiletjs+eJ/J5/f9zh9Bnr157 datacourier@datahub" >~datacourier/.ssh/authorized_keys'
sudo chmod 0400 ~datacourier/.ssh/authorized_keys

sudo chown -R datacourier:datacourier ~datacourier

sudo bash -c 'cat >/etc/ssh/sshd_config.d/10-datacourier.conf' <<'EOF'
Match User datacourier
    PasswordAuthentication no
    PubkeyAuthentication yes
    AllowTCPForwarding no
    X11Forwarding no
    ForceCommand /usr/bin/rsync --server --sender -vlogDtpre.iLsfxCIvu . data.tgz
EOF

sudo chmod 0400 /etc/ssh/sshd_config.d/10-datacourier.conf

#crontab: cd /tmp && sudo -u postgres pg_dump hotrod_portal >hotrod_portal.sql; cd /home/datacourier && tar -cpf - -X /root/.local/share/tar/exclude /root/.local/share/tar/exclude /etc /root /home /opt/hotrod* /var/lib/{hotrod*,grafana,caddy} /var/spool/cron/crontabs | pigz --rsyncable --fast >data.tgz; rm -f /tmp/hotrod_portal.sql

sudo sshd -t && sudo systemctl restart sshd

exit 0
