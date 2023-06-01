#!/bin/bash

set -euo pipefail

grep -q "za.archive.ubuntu.com" /etc/apt/sources.list || cat >/etc/apt/sources.list <<'EOF'
deb http://za.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://za.archive.ubuntu.com/ubuntu/ jammy-security main restricted
deb http://za.archive.ubuntu.com/ubuntu/ jammy-security universe
deb http://za.archive.ubuntu.com/ubuntu/ jammy-security multiverse
EOF

cat >/etc/apt/apt.conf.d/10squid-proxy <<'EOF'
Acquire::http { Proxy "http://proxy.ephemeric.lan:3128"; };
Acquire::https { Proxy "DIRECT"; };
EOF

if [[ ! -f /etc/docker/daemon.json ]]; then

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

update-ca-certificates
fi

grep -q "proxy.ephemeric.lan" /etc/hosts || cat >>/etc/hosts <<'EOF'
192.168.122.2 proxy.ephemeric.lan
EOF

exit 0
