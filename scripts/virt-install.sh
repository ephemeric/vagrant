#!/usr/bin/env bash

virt-install \
--boot cdrom \
--machine q35 \
--os-variant=ubuntu22.04 \
--name ubuntu2204.ephemeric.lan \
--memory 4096 \
--vcpus 2 \
--controller type=scsi,model=virtio-scsi,driver.iommu=on \
--controller type=virtio-serial,driver.iommu=on \
--network type=direct,source=eth0 \
--rng /dev/random,driver.iommu=on \
--disk bus=scsi,size=20 \
--graphics none \
--location ubuntu-22.04.2-live-server-amd64.iso \
--cdrom ubuntu-22.04.2-live-server-amd64.iso

exit 0
