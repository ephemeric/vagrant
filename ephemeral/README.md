# Lab

## Vagrant

### Add VM

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
