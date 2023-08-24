#!/usr/bin/env bash

set -euo pipefail

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

exit 0
