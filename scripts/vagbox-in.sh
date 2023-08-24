#!/usr/bin/env bash

set -Eeuo pipefail -o functrace

vagrant destroy -f test && vagrant up test && vagrant halt test && sudo virt-sysprep -d ephemeric_test --operations defaults,-ssh-userdir,-lvm-uuids --firstboot-command 'dpkg-reconfigure openssh-server' --run-command /vagrant/scripts/cleanup.sh

sudo chmod 0644 /var/lib/libvirt/images/ephemeric_test.img

qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/ephemeric_test.img /home/robertg/.vagrant.d/boxes/panoptix-VAGRANTSLASH-hotrod/0.0.1/libvirt/box.img

[[ -f /var/lib/libvirt/images/panoptix-VAGRANTSLASH-hotrod_vagrant_box_image_0.0.1_box.img ]] && sudo virsh vol-delete --pool default --vol panoptix-VAGRANTSLASH-hotrod_vagrant_box_image_0.0.1_box.img

vagrant destroy -f

sync

exit 0
