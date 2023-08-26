# Vagrant

## Flow

Add box, boot, scripts, cleanup.sh, offline utils, rebase, copy to version dir, vagrant up.

## Add VM

### Config

Copy config/<existing config> to config/<newvm>.

Edit at a minimum after running `vagrantfile-utils.sh` to establish IP and MAC:

```sh
config.vm.define "<newvm>" do |this|
this.vm.hostname = "<newvm>" + DOMAIN
:ip => "192.168.235.<ii>", \
v.base_mac = "000c2984db<hh>"
v.base_address = "192.168.235.<ii>"
```

Edit Vagrantfile and append `load config/<vm>`

### Rsync `homedir`

Note potential collisions in the `/vagrant/` namespace. See `uploads` for existing symlinks and usernames are reserved. e.g., `/vagrant/robertg`.

### CA

No need to run scripts/provision_ca_certs.sh as certs are valid for ten years. Only for possible SAN updates etc.

All required files are rsync'ed to /vagrant in VM and installed accordingly.

## Vagbox

`vagrant` obtains version from dir path.

```
jasmine :: ~ % ll .vagrant.d/boxes/ephemeric-VAGRANTSLASH-slob/0.0.1/libvirt/
total 1.6G
-rw-r--r-- 1 robertg robertg 1.6G Jul 31 11:44 box.img
-rw-r--r-- 1 robertg robertg    0 May 24 12:21 box_update_check
-rw-r--r-- 1 robertg robertg  234 Jul 31 11:31 info.json
-rw-r--r-- 1 robertg robertg   59 May 23 14:30 metadata.json
-rw-r--r-- 1 robertg robertg 2.1K May 23 14:30 Vagrantfile
```

```
jasmine :: ~ % vagrant box list
generic/ubuntu2004 (libvirt, 4.2.16)
generic/ubuntu2204 (libvirt, 4.2.16)
ephemeric/slob    (libvirt, 0.0.1)
```

### Remove

/etc/machine-id
/etc/cloud/
/run/utmp
/var/lib/cloud/
/var/lib/systemd/random-seed
/var/log/wtmp
/var/log/btmp
/etc/systemd/resolved.conf
/etc/systemd/resolved.conf.d/
/etc/netplan/01-netcfg.yaml

### Truncate

### Disable services.

### Generate files.

### Purge packages.

### Edit files.

### Offline operations.

See `scripts/vagbox-in.sh` and `scripts/vagbox-out.sh`.

### Rebase

This will include the backing file in the output image, no need for `rebase` and `commit`:

```
qemu-img convert -f qcow2 -O qcow2 ephemeric_test.img ephemeric_test.img.new
```
