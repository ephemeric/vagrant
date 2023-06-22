#!/usr/bin/env bash

set -euo pipefail

# TODO: determine OS... do relevent tasks.
#dnf -y install zsh vim policycoreutils-python policycoreutils nmap telnet wget curl tcpdump
dpkg-query --show zsh || apt-get -y install zsh

# Portable for Rocky, Ubuntu, et al.
#getent group wheel || groupadd -r wheel
getent passwd robertg || useradd -c "Robert Gabriel" -m -s /bin/zsh robertg

sudo -iu robertg mkdir -p -m 0700 .ssh
echo "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDKHz85P9rJczwjgMjJu47/iLXBxtfqoSlHXjEnT4ZuDAAAABHNzaDo= robertg@macbook.local" >~robertg/.ssh/authorized_keys
chmod 0400 ~robertg/.ssh/authorized_keys

# No need for `wheel` or `sudo` group membership as explicitly specified below.
cat >/etc/sudoers.d/robertg <<'EOF'
Defaults:robertg !requiretty, env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy SSH_AGENT_PID SSH_AUTH_SOCK"
robertg ALL=(ALL:ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/robertg
visudo -c

#scp -r .zshrc .oh-my-zsh dest:

chown -R robertg:robertg ~robertg

exit 0
