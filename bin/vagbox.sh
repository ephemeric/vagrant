#!/usr/bin/env bash

set -Eeuo pipefail -o functrace

# Pre-prep. Remove backing image file and boxes.
[[ -f /var/lib/libvirt/images/ephemeric-VAGRANTSLASH-vagbox_vagrant_box_image_0.0.1_box.img ]] && sudo virsh vol-delete --pool default --vol ephemeric-VAGRANTSLASH-vagbox_vagrant_box_image_0.0.1_box.img
vagrant destroy -f vagbox test

# Install and provision your requirements.
vagrant up vagbox
vagrant halt vagbox

# Post-prep.
sudo virt-sysprep -d ephemeric_vagbox --operations defaults,-ssh-userdir,-lvm-uuids --firstboot-command 'dpkg-reconfigure openssh-server' --run-command /vagrant/scripts/provision_cleanup.sh

# Export new box.
sudo chmod 0644 /var/lib/libvirt/images/ephemeric_vagbox.img
qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/ephemeric_vagbox.img /home/robertg/.vagrant.d/boxes/ephemeric-VAGRANTSLASH-vagbox/0.0.1/libvirt/box.img

# Cleanup.
vagrant destroy -f vagbox
sync

# Test.
vagrant up test
vagrant ssh test

exit 0
