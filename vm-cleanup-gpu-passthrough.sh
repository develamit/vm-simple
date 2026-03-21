!/bin/bash

VM_NAME="ubuntu2004-a6000-vm"
sudo virsh shutdown ${VM_NAME}
sudo virsh destroy ${VM_NAME}
sudo virsh undefine ${VM_NAME}

sudo rm -f /var/lib/libvirt/images/${VM_NAME}.qcow2
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/${VM_NAME}.qcow2 500G
sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/${VM_NAME}.qcow2
sudo chmod 660 /var/lib/libvirt/images/${VM_NAME}.qcow2
