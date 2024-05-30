# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = "generic/ubuntu2204"
VERSION = "4.2.16"
DOMAIN = ".ephemeric.lan"
ENV["CHANNEL"] = "stable"

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
    config.vm.synced_folder "upload", "/vagrant", type: "rsync"

    # Libvirt.
    config.vm.provider "libvirt" do |l|
        l.default_prefix = "ephemeric_"
        #l.graphics_type = "none"
        #l.management_network_keep = true
        l.management_network_name = "default"
        l.memory = 4096
        l.cpus = 4
    end

    # VMWare.
    config.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "1024"
        v.vmx["numvcpus"] = "4"
        v.vmx["virtualhw.version"] = "16"
    end
end

load "config/robertg"
load "config/splunk"
load "config/ubuntu2204"
load "config/alpine"
load "config/server2019"
#load "config/arch"
#load "config/vagbox"
#load "config/nomad"
#load "config/test"
#load "config/gentoo"
#load "config/slackware14"
#load "config/slackware15"
#load "config/devuan"
#load "config/alma9"
#load "config/rocky9"
#load "config/microos"
#load "config/k8s"
#load "config/rke2"
#load "config/loop"
