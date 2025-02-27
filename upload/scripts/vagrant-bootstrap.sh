#!/bin/bash

set -ETeuo pipefail; shopt -s dotglob failglob

builtin readonly __PROXY="$1"
[[ "$__PROXY" == "false" ]] && exit 0

cat >/tmp/proxy.sh <<'EOF'
export HTTP_PROXY="http://proxy.ephemeric.lan:3128"
export http_proxy="http://proxy.ephemeric.lan:3128"
export HTTPS_PROXY="http://proxy.ephemeric.lan:3128"
export https_proxy="http://proxy.ephemeric.lan:3128"
export NO_PROXY="localhost,ephemeric.lan,ephemeric.lan,127.0.0.1,192.168.235.0/24,192.168.0.0/24,192.168.122.0/24"
export no_proxy="localhost,ephemeric.lan,ephemeric.lan,127.0.0.1,192.168.235.0/24,192.168.0.0/24,192.168.122.0/24"
EOF

# Easy-RSA CA cert.
cat >/tmp/easy-rsa-ca.crt <<'EOF'
-----BEGIN CERTIFICATE-----
MIIDSzCCAjOgAwIBAgIUdTPONst38MbxxIjstBYgJmB5cZ4wDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjEwNjE4MTQzMjI2WhcNMzEw
NjE2MTQzMjI2WjAWMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAKRB+oO9eTvldeY7hbDmDcGA9aUDBQwTOaSZ/D3S
qhMMQ5kNTjIYP/YTPtGfJ+CKydaKp/CZoqdL3oSVol078ycHTgLJBMHSyEWDtkZw
/To0bbh/Q8ZpRVqjExbuYxDgPn70ucyeAHzUlGYMs56urhKtTvTHPljsa13EIwu0
IJC/TXwoIZ9yv8OtazI3TWb3jLCdDb7Ej7Kq1ExjWkVNqzzh3e63TkGqTtJO/nDj
NB1jXe27mkDuBGyAf53Jcyfvhom4ELRpQRTpsfQC6lfvK2m7sC9toGK/98vvMPko
xQhfk6aJ/rltPLtoof4kcEZ+qntyo8SdTq37DdqkSkaK7S0CAwEAAaOBkDCBjTAd
BgNVHQ4EFgQUNcGEQoltzOIPDv6ZPVtNbEHkItswUQYDVR0jBEowSIAUNcGEQolt
zOIPDv6ZPVtNbEHkItuhGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENBghR1M842
y3fwxvHEiOy0FiAmYHlxnjAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkq
hkiG9w0BAQsFAAOCAQEAd4DcPzINMA5il4/iNV5lDQwS5+o2h+dq95g+8hYPFkJg
y4onAGcdrIWi+2vBdd4WR6i908bHNXo7Rrftn4IzesA9+3Q2U2aUgYi9p+hGy3eZ
HhxdfAXLUnjVth+VsFas7ud5pcoN15DNMLM4qZQ6k+i8uW/WqZblimg9UfgdtfLP
iCeAvMOe2XHyOfoAXiUXg9RItPJK12wvUw2V1OCfADnnHDaNRG9sd+xH3TaoqQsj
sc3ysian/ruB6Sisqv3Lgd3pek7rPnvU/mw4wTACjyBnriZBhILu0/g349nyV3jF
bw45O9+4WmoOES4TUVF3Oe/Mh9Ta/2nXvBJeOEGQjw==
-----END CERTIFICATE-----
EOF

cat >/tmp/arch-mirrorlist <<'EOF'
##
## Arch Linux repository mirrorlist
## Generated on 2024-07-01
##

## South Africa
Server = http://archlinux.za.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = https://archlinux.za.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = http://za.mirror.archlinux-br.org/$repo/os/$arch
Server = http://mirror.is.co.za/mirror/archlinux.org/$repo/os/$arch
Server = http://mirrors.urbanwave.co.za/archlinux/$repo/os/$arch
Server = https://mirrors.urbanwave.co.za/archlinux/$repo/os/$arch
EOF

__distro="$(hostnamectl | grep -oP "Operating\sSystem:\s\K(\w+)")"
case "$__distro" in
    Arch)
        #rm -fr /etc/pacman.d/gnupg/
        #pacman-key --init
        #pacman-key --populate archlinux
        \cp /tmp/arch-mirrorlist /etc/pacman.d/mirrorlist
        trust anchor /tmp/easy-rsa-ca.crt
        update-ca-trust
        pacman -Sy --noconfirm zsh vim git
        ;;
    AlmaLinux)
        cp /tmp/easy-rsa-ca.crt /etc/pki/ca-trust/source/anchors/
        update-ca-trust
        #dnf config-manager --save --setopt="*.proxy=http://proxy.ephemeric.lan:3128"
        #dnf clean all
        #dnf makecache
        dnf -y install zsh
        chmod 0440 /etc/sudoers.d/vagrant
        builtin echo "alias robg='sudo -iu robertg'" >/etc/profile.d/slob.sh
        ;;
    Ubuntu)
        # Robox builds set their DNS. I'm using mine.
        rm -f /etc/netplan/01-netcfg.yaml
        netplan apply
        sed -i.old "/ubuntu2204.localdomain/d" /etc/hosts
        rm -f /etc/systemd/resolved.conf
        rm -fr /etc/systemd/resolved.conf.d
        systemctl restart systemd-resolved
        cp /tmp/easy-rsa-ca.crt /usr/local/share/ca-certificates/
        update-ca-certificates
        # Repository.
        grep -q "za.archive.ubuntu.com" /etc/apt/sources.list || cat >/etc/apt/sources.list <<'EOF'
deb http://za.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://za.archive.ubuntu.com/ubuntu jammy-security main restricted
deb http://za.archive.ubuntu.com/ubuntu jammy-security universe
deb http://za.archive.ubuntu.com/ubuntu jammy-security multiverse
EOF
cat >/etc/apt/apt.conf.d/10squid-proxy <<'EOF'
Acquire::http { Proxy "http://proxy.ephemeric.lan:3128"; };
Acquire::Retries "10";
Acquire::http::Timeout "60";
Acquire::https::Timeout "60";
APT::Get::Assume-Yes "true";
APT::Install-Recommends "false";
APT::Install-Suggests "false";
Debug::Acquire::http "false";
Debug::Acquire::https "false";
EOF
        DEBIAN_FRONTEND="noninteractive" apt-get -y update
        DEBIAN_FRONTEND="noninteractive" apt-get -y install zsh
        ;;
    *)
        echo "Unknown distro."
        exit 1
        ;;
    esac

# Me.
if ! getent passwd robertg >/dev/null; then
# Should be portable across any distro.
useradd -c "Robert Gabriel" -m -s /bin/zsh robertg
# Sudo: no need for `wheel` or `sudo` group membership as explicitly specified below.
cat >/etc/sudoers.d/robertg <<'EOF'
Defaults:robertg !requiretty, env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY NO_PROXY SSH_AGENT_PID SSH_AUTH_SOCK"
robertg ALL=(ALL:ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/robertg
visudo -c
# SSH.
sudo -iu robertg mkdir -p -m 0700 .ssh/cp tmp
echo "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDKHz85P9rJczwjgMjJu47/iLXBxtfqoSlHXjEnT4ZuDAAAABHNzaDo= robertg@macbook.local" >~robertg/.ssh/authorized_keys
cat >~robertg/.ssh/config <<'EOF'
Host github.com
    HostName github.com
    user git
Host *
    ServerAliveInterval 15
    ServerAliveCountMax 3
    TCPKeepAlive no
    ExitOnForwardFailure yes
    VisualHostKey no
    ForwardAgent no
    PubkeyAuthentication yes
    ControlPath ~/.ssh/cp/%r@%h:%p
    ControlMaster auto
    ControlPersist 10m
EOF
chmod 0400 ~robertg/.ssh/{config,authorized_keys}
# Fixperms.
# Install dotfiles.
\cp -a /vagrant/robertg/* /home/robertg/
chown -R robertg:robertg ~robertg
fi

exit 0

# Docker.
#mkdir -pm 0755 /etc/docker
#cat >/etc/docker/daemon.json <<'EOF'
#{
#  "registry-mirrors": ["https://registry.ephemeric.lan"]
#}
#EOF
