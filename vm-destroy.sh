!/bin/bash

VM_NAME="ubuntu2004-a6000-vm"
sudo virsh shutdown ${VM_NAME}
sudo virsh destroy ${VM_NAME}
sudo virsh undefine ${VM_NAME}
