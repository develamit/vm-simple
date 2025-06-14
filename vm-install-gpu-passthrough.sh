#!/bin/bash

# --- VM Configuration Parameters ---
#VM_NAME="ubuntu2204-a6000-vm"
VM_NAME="ubuntu2004-a6000-vm"
VM_MEMORY="65536" # 64 GB RAM
VM_VCPUS="32"    # 32 Virtual CPU cores
VM_DISK_SIZE="500" # 500 GB Disk size (in GB) <-- Changed this line
# --- End VM Configuration Parameters ---

# PCI IDs for the GPU to passthrough (confirmed 0000:86:00.0)
GPU_PCI_ID="0000:86:00.0"
GPU_AUDIO_PCI_ID="0000:86:00.1"

# ISO Path for Ubuntu 22.04.5 Live Server
#ISO_PATH="/var/lib/libvirt/images/ubuntu-22.04.5-live-server-amd64.iso"
ISO_PATH="/var/lib/libvirt/images/ubuntu-20.04.6-live-server-amd64.iso"

# Disk Path for the VM
DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"

sudo virt-install \
--name "${VM_NAME}" \
--memory "${VM_MEMORY}" \
--vcpus "${VM_VCPUS}" \
--os-type linux \
--os-variant ubuntu20.04 \
--disk path="${DISK_PATH}",bus=virtio,format=qcow2,size="${VM_DISK_SIZE}" \
--network default,model=virtio \
--graphics none \
--hostdev "${GPU_PCI_ID}" \
--hostdev "${GPU_AUDIO_PCI_ID}" \
--console pty,target_type=serial \
--location "${ISO_PATH}",kernel=casper/vmlinuz,initrd=casper/initrd \
--extra-args "console=ttyS0,115200n8 serial" \
--autostart \
--boot hd,cdrom \
--virt-type kvm \
--rng /dev/urandom \
--noautoconsole
