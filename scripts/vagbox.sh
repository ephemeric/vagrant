#!/usr/bin/env bash

set -Eeuo pipefail -o functrace

[[ -f /var/lib/libvirt/images/ephemeric-VAGRANTSLASH-vagbox_vagrant_box_image_0.0.1_box.img ]] && sudo virsh vol-delete --pool default --vol ephemeric-VAGRANTSLASH-vagbox_vagrant_box_image_0.0.1_box.img

vagrant destroy -f vagbox

vagrant up vagbox

vagrant halt vagbox

sudo virt-sysprep -d ephemeric_vagbox --operations defaults,-ssh-userdir,-lvm-uuids --firstboot-command 'dpkg-reconfigure openssh-server' --run-command /vagrant/scripts/cleanup.sh

sudo chmod 0644 /var/lib/libvirt/images/ephemeric_vagbox.img

qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/ephemeric_vagbox.img /home/robertg/.vagrant.d/boxes/ephemeric-VAGRANTSLASH-vagbox/0.0.1/libvirt/box.img

vagrant destroy -f

sync

exit 0
