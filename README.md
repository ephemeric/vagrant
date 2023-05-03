# VirtualBox.

VBoxManage modifyvm "<vm>" --natdnshostresolver1 on
VBoxManage modifyvm "<vm>" --nic2 natnetwork

VBoxManage startvm "<vm>" --type headless

 VBoxManage controlvm <uuid | vmname> pause

  VBoxManage controlvm <uuid | vmname> resume

  VBoxManage controlvm <uuid | vmname> reset

  VBoxManage controlvm <uuid | vmname> poweroff

  VBoxManage controlvm <uuid | vmname> savestate

  VBoxManage controlvm <uuid | vmname> acpipowerbutton

  VBoxManage controlvm <uuid | vmname> acpisleepbutton

  VBoxManage controlvm <uuid | vmname> reboot

  VBoxManage controlvm <uuid | vmname> shutdown [--force]

VBoxManage list runningvms
VBoxManage list vms

VBoxManage guestproperty enumerate "<vm>" | grep timesync | sort
VBoxManage guestproperty set "<vm>" "/VirtualBox/GuestAdd/VBoxService/--timesync-interval" 1000
VBoxManage guestproperty set "<vm>" "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore" 1
VBoxManage guestproperty set "<vm>" "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust" 100
VBoxManage guestproperty set "<vm>" "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold" 1000
