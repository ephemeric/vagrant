#!/bin/bash

set -euo pipefail; shopt -s dotglob failglob

grep -q "za.archive.ubuntu.com" /etc/apt/sources.list || cat >/etc/apt/sources.list <<'EOF'
deb http://za.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-security universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy-security multiverse
EOF

cat >/etc/profile.d/proxy.sh <<'EOF'
export http_proxy="http://proxy.ephemeric.lan:3128"
export https_proxy="http://proxy.ephemeric.lan:3128"
export no_proxy="registry.k8s.io,127.0.0.1,localhost,master-node,worker-node01,worker-node02,worker-node03,ephemeric.lan,172.16.,172.17.,172.16.1.0/16,172.17.1.0/18,192.168.235.,192.168.235.0/24"
export HTTP_PROXY="http://proxy.ephemeric.lan:3128"
export HTTPS_PROXY="http://proxy.ephemeric.lan:3128"
export NO_PROXY="registry.k8s.io,127.0.0.1,localhost,master-node,worker-node01,worker-node02,worker-node03,ephemeric.lan,172.16.,172.17.,172.16.1.0/16,172.17.1.0/18,192.168.235.,192.168.235.0/24"
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

mkdir -pm 0755 /etc/docker/certs.d/{docker.io,registry-1.docker.io}

cat >/etc/docker/daemon.json <<'EOF'
{
  "registry-mirrors": ["https://proxy.ephemeric.lan"]
}
EOF

cat >/etc/docker/certs.d/docker.io/ca.crt <<'EOF'
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

cat >/etc/docker/certs.d/registry-1.docker.io/ca.crt <<'EOF'
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

#cat >/etc/ssl/certs/ca-certificates.crt <<'EOF'
cat >/usr/local/share/ca-certificates/registry-mirror.crt <<'EOF'
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

#cat >/etc/ssl/certs/ca-certificates.crt <<'EOF'
cat >/usr/local/share/ca-certificates/squid-proxy.crt <<'EOF'
-----BEGIN CERTIFICATE-----
MIIEDzCCAvegAwIBAgIUI1EFQsfLjKbFTBedIM2sJJ6Dqd4wDQYJKoZIhvcNAQEL
BQAwgZYxCzAJBgNVBAYTAlpBMRAwDgYDVQQIDAdHYXV0ZW5nMREwDwYDVQQHDAhQ
cmV0b3JpYTEOMAwGA1UECgwFVW5pdDgxEDAOBgNVBAsMB0hhY2tpbmcxHDAaBgNV
BAMME3Byb3h5LmVwaGVtZXJpYy5sYW4xIjAgBgkqhkiG9w0BCQEWE2FkbWluQGVw
aGVtZXJpYy5sYW4wHhcNMjMwNTIxMTkxMzI3WhcNMjQwNTIwMTkxMzI3WjCBljEL
MAkGA1UEBhMCWkExEDAOBgNVBAgMB0dhdXRlbmcxETAPBgNVBAcMCFByZXRvcmlh
MQ4wDAYDVQQKDAVVbml0ODEQMA4GA1UECwwHSGFja2luZzEcMBoGA1UEAwwTcHJv
eHkuZXBoZW1lcmljLmxhbjEiMCAGCSqGSIb3DQEJARYTYWRtaW5AZXBoZW1lcmlj
LmxhbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK7+CrDt1fwIun6d
VJ4/JqG8tHpEtvPphWiOMBRsza+l9pXAqYt/FbwbiXs1Ap+GM8MzHsAXQkYwn/oy
/XpzsdaT4a9siKCshfWTfHPTvOsWWXYmVmyuHWYFdlGaNhLRXNwiNH02xlqqHY3X
AxvNk1LftgTWUyUrhW07arOuhtLP6bmBDx4dsM9qsctMbG5/yPpvchBk7JQU/Jl2
6bVu1WCkIJRKWkybFbb9zbeJB+BJiEud16kTQ6gmj/lV4qWcTFpCS/FEbGZxLBvc
LWqG5ybhyaHoO/UsQv9uMdXSCiaFv0/vLdra7uIYBGbkly3QbLpaShSKc1bKszMT
29nYPj8CAwEAAaNTMFEwHQYDVR0OBBYEFN9YgBlRpLDLSPMXVYWjTHr26gYyMB8G
A1UdIwQYMBaAFN9YgBlRpLDLSPMXVYWjTHr26gYyMA8GA1UdEwEB/wQFMAMBAf8w
DQYJKoZIhvcNAQELBQADggEBAIKj4s445/85IFVtdL+X3aKGTCtim0TmyiyaFc1s
I9sdiaE8LqQV/AlWGbiXzZylDf3IPW5pV/50z7c39vZAr2MxhHPVkPtSOUJTlNFS
8j2xjJQB1bhIUsalpvRG3SVcpFMS2oOzqKLGXWNDaPmewtJBwEgcRaAQ1NSTvmBp
Ubgfo49n4tf6FWCmaAQyNxOepm8UqVr7N/DIhYKkYM3wsX/N/DOKAqtKDppzY2WF
ZvnGzbrmJ645nvVTUbqEQ0/cH2mk76a8X6cKgtZ0Uink8aqmrIKvx69jpM27YYnT
4DjabnGpJ7oet9TBEsvPL/q6YZHpZTl1B5FB6FL8iQYmmbA=
-----END CERTIFICATE-----
EOF
update-ca-certificates 2>/dev/null

## TODO: Rocky9 et al.
#cat >/etc/pki/ca-trust/source/anchors/squid-proxy.crt <<'EOF'
#-----BEGIN CERTIFICATE-----
#-----END CERTIFICATE-----
#EOF
#update-ca-trust

## /etc/hosts
grep -q "proxy.ephemeric.lan" /etc/hosts || cat >>/etc/hosts <<'EOF'
192.168.122.2 proxy.ephemeric.lan proxy
192.168.122.3 registry.ephemeric.lan registry
192.168.122.4 registry.k8s.io
EOF

# TODO: determine OS... do relevent tasks.
#dnf -y install zsh vim policycoreutils-python policycoreutils nmap telnet wget curl tcpdump
DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet update
dpkg -l zsh | grep -q "ii" || DEBIAN_FRONTEND="noninteractive" apt-get -y --quiet install zsh

# Portable for Rocky, Ubuntu, et al.
#getent group wheel || groupadd -r wheel
getent passwd robertg || useradd -c "Robert Gabriel" -m -s /bin/zsh robertg

sudo -iu robertg mkdir -p -m 0700 .ssh tmp
echo "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDKHz85P9rJczwjgMjJu47/iLXBxtfqoSlHXjEnT4ZuDAAAABHNzaDo= robertg@macbook.local" >~robertg/.ssh/authorized_keys
chmod 0400 ~robertg/.ssh/authorized_keys

# No need for `wheel` or `sudo` group membership as explicitly specified below.
cat >/etc/sudoers.d/robertg <<'EOF'
Defaults:robertg !requiretty, env_keep += "http_proxy https_proxy ftp_proxy all_proxy no_proxy SSH_AGENT_PID SSH_AUTH_SOCK"
robertg ALL=(ALL:ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/robertg
visudo -c

chown -R robertg:robertg ~robertg

# Vagrant specific.
cd /vagrant/robertg/
mv * ~robertg/
chown -R robertg:robertg ~robertg/

exit 0
