# Vagrant

## Flow

Add box, boot, scripts, cleanup.sh, offline utils, rebase, copy to version dir, vagrant up.

## Rebase

This will include the backing file in the output image, no need for `rebase` and `commit`:

```
qemu-img convert -f qcow2 -O qcow2 ephemeric_test.img ephemeric_test.img.new
```

## Errors

### `curl`

This seems to be a transient, networking error, seemingly corrected by the following command:

```
pipes: curl: (35) error:0A0000D9:SSL routines::unsolicited extension
```

```
curl --write-out '%{http_code}' --output api_response --fail --location --connect-timeout 60 --retry-connrefused --retry 3 --retry-delay 5 --retry-max-time 60 --silent --show-error https://httpstat.us/200 >http_code
```

```
jasmine :: ~ % ll .vagrant.d/boxes/panoptix-VAGRANTSLASH-hotrod/0.0.1/libvirt/
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
panoptix/hotrod    (libvirt, 0.0.1)
```
