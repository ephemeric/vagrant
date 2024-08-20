#!/usr/bin/env bash

set -ETueo pipefail

arg_channel="$1"
arg_release="$2"

cp /vagrant/bin/ephemeric .

export DEBIAN_FRONTEND="noninteractive"
cp caddy-stable.list /etc/apt/sources.list.d/
cp caddy-stable-archive-keyring.gpg /usr/share/keyrings/
apt-get update
apt-get -y install debconf-utils dpkg-sig debmake devscripts libdistro-info-perl build-essential debhelper-compat reprepro caddy

# Noninteractive. Updates debian/changelog for debuild.
export DEBEMAIL="Vagrant User <vagrant@ephemeric.com>"
debchange -b -v "$arg_release" -D "jammy" "Vagrant automated build."

# Looks for version in debian/changelog, see `man debchange`. Asks for the GPG key of the user who last edited debian/changelog.
export GNUPGHOME="/vagrant/dpkgbuild/.gnupg/"
export DEB_BUILD_OPTIONS="noddebs"
# Signs buildinfo, changes files in ../.
debuild -i -b -sa

# Signs the actual package itself. When installing: dpkg-sig --verify *.deb.
dpkg-sig --sign builder "../ephemeric_${arg_release}_amd64.deb"

# Repo.
mkdir -p /var/www/repo/conf

# jammy, amd64.
cp distributions /var/www/repo/conf/

# Only requires above file in place. Repo can be blown away entirely and recreated.
reprepro -b /var/www/repo/ includedeb jammy "../ephemeric_${arg_release}_amd64.deb"

# Users can: wget | gpg --dearmor -o /usr/share/keyrings/ephemeric.gpg
gpg --export --armor >/var/www/repo/ephemeric.gpg

# apt-key is deprecated.
cat /var/www/repo/ephemeric.gpg | gpg --dearmor -o /usr/share/keyrings/ephemeric.gpg

# Correlates to distributions.
builtin echo "deb [signed-by=/usr/share/keyrings/ephemeric.gpg] https://repo.ephemeric.lan jammy main" \
>/etc/apt/sources.list.d/ephemeric.list

# Caddy internal TLS, do not verify.
cp 80-ephemeric /etc/apt/apt.conf.d/

# Serve the repo.
cp Caddyfile /etc/caddy/
systemctl restart caddy

# So we can be ready to apt-get install ephemeric
apt-get update

exit 0
