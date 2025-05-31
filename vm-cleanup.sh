!/bin/bash

sudo virsh destroy ubuntu_server_vm
sudo virsh shutdown ubuntu_server_vm
sudo virsh undefine ubuntu_server_vm --remove-all-storage

sudo qemu-img create -f qcow2 /var/lib/libvirt/images/ubuntu_server_vm.qcow2 50G
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/ubuntu_server_vm.qcow2
