#!/bin/bash
sudo virt-install \
--name ubuntu2004-simple-server-vm \
--memory 8192 \
--vcpus 8 \
--os-type linux \
--os-variant ubuntu20.04 \
--disk path=/var/lib/libvirt/images/ubuntu_server_vm.qcow2,bus=virtio,format=qcow2 \
--network default,model=virtio \
--graphics none \
--console pty,target_type=serial \
--location /var/lib/libvirt/images/ubuntu-20.04.6-live-server-amd64.iso,kernel=casper/vmlinuz,initrd=casper/initrd \
--extra-args "console=ttyS0,115200n8 serial" \
--autostart \
--boot hd,cdrom \
--virt-type kvm \
--rng /dev/urandom \
--noautoconsole
