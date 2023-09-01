# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = "generic/ubuntu2204"
VERSION = "4.2.16"
DOMAIN = ".ephemeric.lan"

Vagrant.configure("2") do |config|

    config.vm.box_check_update = false
    # Undesired: 127.0.1.1, 127.0.0.1, 127.0.2.1 entries.
    config.vm.allow_hosts_modification = false
    # See below: `load "config/<user>"` for personal prefs. Please DO NOT add port forwards here!
    #
    # Slow: SSH connection is "reused" but very slow.
    #config.vm.provision "file", source: "upload", destination: "/tmp/"
    #
    # Cannot sync to /tmp/ as Vagrant/rsync breaks /tmp to 0775 instead of the default 1777.
    config.vm.synced_folder "upload", "/vagrant/", type: "rsync"

    # Libvirt.
    config.vm.provider "libvirt" do |l|
        l.default_prefix = "ephemeric_"
        l.graphics_type = "none"
        l.management_network_name = "default"
        l.management_network_keep = true
        l.memory = 8192
        l.cpus = 32
    end

    # VMWare.
    config.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "1024"
        v.vmx["numvcpus"] = "4"
        v.vmx["virtualhw.version"] = "16"
    end
end

# Squid proxy for APT mirror and Docker pull-through proxy registry cache.
load "config/robertg"
# Machines.
load "config/k8"
load "config/generator"
load "config/splunk"
load "config/vagbox"
load "config/test"