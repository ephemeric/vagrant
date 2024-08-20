#!/usr/bin/env bash
#
# Not meant to be installed on machines. Files are installed.

set -euo pipefail

__host="$1"
__domain="$2"
__org="${__domain%*.*}"
__cn="$__host.$__domain"

# Generate a self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout selfsigned.key -out selfsigned.crt -days 365 -nodes -subj "/CN=$__cn/O=$__org/C=ZA"

# CA private key.
openssl genrsa -out $__org.key 4096

# Create CA cert.
openssl req -x509 -new -nodes -key $__org.key -sha256 -days 365 -out $__org.crt -subj "/CN=$__org/C=ZA/ST=Gauteng/L=Johannesburg/O=$__org"

# Server CSR.
openssl req -new -nodes -out $__cn.csr -newkey rsa:4096 -keyout $__cn.key -subj "/CN=$__cn/C=ZA/ST=Gauteng/L=Johannesburg/O=$__org"

# Create a v3 ext file for SAN properties.
cat >"$__cn".v3.ext <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = "$__cn"
IP.1 = 192.168.235.10
EOF

#openssl x509 -req -nodes -in $__cn.csr -CA $__domain.crt -CAkey $__domain.key -CAcreateserial -out $__cn.crt -days 365 -sha256 -extfile $__cn.v3.ext
openssl x509 -req -in $__cn.csr -CA $__org.crt -CAkey $__org.key -CAcreateserial -out $__cn.crt -days 365 -extfile $__cn.v3.ext

exit 0
