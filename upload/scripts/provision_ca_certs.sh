#!/usr/bin/env bash
#
# Not meant to be installed on machines. Copy files as required.

set -euo pipefail

# Generate a self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt -days 3650 -nodes -subj "/CN=ephemeric/O=Ephemeric/C=ZA"

CANAME=EphemericCA

# CA private key.
#openssl genrsa -aes256 -out $CANAME.key 4096
openssl genrsa -out $CANAME.key 4096

# Create CA cert.
openssl req -x509 -new -nodes -key $CANAME.key -sha256 -days 3650 -out $CANAME.crt -subj '/CN=ephemeric/C=ZA/ST=Gauteng/L=Johannesburg/O=Ephemeric'

# Server CSR.
MYCERT=server.ephemeric.lan
openssl req -new -nodes -out $MYCERT.csr -newkey rsa:4096 -keyout $MYCERT.key -subj '/CN=server.ephemeric.lan/C=ZA/ST=Gauteng/L=Johannesburg/O=Ephemeric'

# Create a v3 ext file for SAN properties.
cat >$MYCERT.v3.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = server.ephemeric.lan
DNS.2 = server1.ephemeric.lan
DNS.3 = server2.ephemeric.lan
DNS.4 = server3.ephemeric.lan
IP.1 = 192.168.235.10
EOF

openssl x509 -req -nodes -in $MYCERT.csr -CA $CANAME.crt -CAkey $CANAME.key -CAcreateserial -out $MYCERT.crt -days 3650 -sha256 -extfile $MYCERT.v3.ext

exit 0
