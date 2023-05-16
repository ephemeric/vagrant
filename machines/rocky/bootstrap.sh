#!/bin/bash

yum -y install zsh vim policycoreutils-python policycoreutils nmap telnet wget curl tcpdump

#apt install zsh
#groupadd -r wheel

useradd -c "Robert Gabriel" -m -s /bin/zsh -G wheel robertg

sudo -iu robertg mkdir -m 0700 .ssh
echo "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDKHz85P9rJczwjgMjJu47/iLXBxtfqoSlHXjEnT4ZuDAAAABHNzaDo= robertg@macbook.local" >~robertg/.ssh/authorized_keys
chmod 0400 ~robertg/.ssh/authorized_keys

echo "robertg ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers.d/robertg
chmod 0400 /etc/sudoers.d/robertg

mv /vagrant/.zsh* /vagrant/.iterm2* /vagrant/.vimrc /vagrant/.oh-my-zsh /vagrant/.gitconfig ~robertg
#scp -r .zshrc .oh-my-zsh dest:

chown -R robertg:robertg ~robertg

echo "-----BEGIN CERTIFICATE-----
MIIGETCCA/mgAwIBAgIUVS+HdaeAQwbiqFA2c8uG2PiTg0swDQYJKoZIhvcNAQEL
BQAwgZcxCzAJBgNVBAYTAlpBMRAwDgYDVQQIDAdHYXV0ZW5nMREwDwYDVQQHDAhQ
cmV0b3JpYTEOMAwGA1UECgwFVW5pdDgxEDAOBgNVBAsMB0hhY2tpbmcxHDAaBgNV
BAMME3NxdWlkLmVwaGVtZXJpYy5sYW4xIzAhBgkqhkiG9w0BCQEWFGVwaGVtZXJp
Y0BpY2xvdWQuY29tMB4XDTIxMDYxODE2NTM1NloXDTIyMDYxODE2NTM1NlowgZcx
CzAJBgNVBAYTAlpBMRAwDgYDVQQIDAdHYXV0ZW5nMREwDwYDVQQHDAhQcmV0b3Jp
YTEOMAwGA1UECgwFVW5pdDgxEDAOBgNVBAsMB0hhY2tpbmcxHDAaBgNVBAMME3Nx
dWlkLmVwaGVtZXJpYy5sYW4xIzAhBgkqhkiG9w0BCQEWFGVwaGVtZXJpY0BpY2xv
dWQuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsVkHlFN1Uct8
baVkzALMztvkd0HtMp72wNiWgxn77ybRlSZn1UKZz1gIF9cVf2CzGQriLZIXWFwH
lzoe6qAhl88M7/hKsfKbRJyG/bjpMOapktOgZcBKP6N12Kmw/87cmbzB6rasfPha
j6qft4zpq8LG81skDwfAz6rHIyBv7TENZyksjdDU6QAImCez/ohq+/v04TWP2R+8
Ew0n3uVMGnDm4Cwn0GsPt/wMQmabTia/W8odktqHmVHtJcwzV0wX4hY+MXbj14R8
QtGTlLXYxw0WWiBn27aYrNkguVC/ZmGD8vRV1Z/7PSoyF/x9JPUbKbeFt2M1l2kX
rDkdeR0dEnZwf/ttAvES9GAVofHkXFwqT8PCOeqACgCoAdfD01IDjZbgFzWkYGR6
UxQThgPpNsdS8tSJBWkvoWf/Z1MOzvgomhVU+b/Q1+ex1f4WBypt5ZEu+UMUdXe8
sFluL/YLNWh6lsCm8paTQX5k4ZAVkHrVyAHFXkxaFg7DuzNLkShWuciddXQxl5xE
r9A4OBipr5lyWdmV6kjTtW2rb8quen5UBF27rpsLURjJchYGWDGLnwDrIGf+Mjkd
qhy2CkUkN/xAyH/29Tu7/6MHIkhVEOHLu7QLuXqKTQwoDZ3mx8NM8F9BXTQ6elbS
q66HMhgXyAaMmKtwiDCTgjwQMym6hu8CAwEAAaNTMFEwHQYDVR0OBBYEFPhRKzBt
fDE5NXEamZ2urIsrJKNuMB8GA1UdIwQYMBaAFPhRKzBtfDE5NXEamZ2urIsrJKNu
MA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggIBAFCHO7ZVt1NjqzJ+
/PvA9f3BQiIkI6ZY+R9P+kom7dYTyRWMi6lPMnHGMxYGNZBWuOcUaHgzjcj1jv9T
GT3rUY2DeyEw3HrjTh3qS2MUWseIgBaDbVuHlIhn/ea/BZAYdFO4vV6uTR1/UEZA
KoEsBh8znFg/57eYCz4bgOWpYZav0WDm1ZLp+JsWUsyYODgBc9Q+/2rmCLIc1U3K
fb0ph7jycY+S5jHAtSPRehXye1KSTl300np6CZTO2duryM1heDJcEHUSwq8LXH2G
MzDJxxWKGN7sUbUuOmj0GlnedZFJu23ahdL8SKnxcrjPTLBh/wyTFaoui2dGSu76
OsnF+0r4tZpyFPsg5UGDn6jPW6XfHllvlPl3W/ox2t/nAbDuHFjBdMbflK68Idic
fU9B5tN22zyYWYdmq0gv8PX6oW9M4pAu0m99uHSkeL4T1dP+36uJUrngSg+DjKZr
uLAskBnni7NAmr15J+LAevAudEnAdPUFj4KxcIyJeOYMPoJM7FxQszF2N9AbCjeW
q2ppi5pHtwNEuq0+6e/J3yXfPgjDl+1RgZ/f3Sn7p3SobMaed1nvSxQHZ1xQUJe7
Z973Iq3e9e2jlJ86gyc7SDfZ0R9wHb7PbkXdpxi7ErFebaRK6a8se3OkMb43T1rO
VwMLyhtPcrSCLqSDPL+AH3/sbq7e
-----END CERTIFICATE-----" >/etc/pki/ca-trust/source/anchors/squid.pem

update-ca-trust

#echo 'proxy=http://192.168.121.1:3128' >>/etc/yum.conf

exit 0
