#!/bin/bash

# Define the PCI IDs of the GPU and its audio device intended for the HOST
HOST_GPU_PCI="0000:18:00.0"
HOST_AUDIO_PCI="0000:18:00.1" # If your GPU has an associated audio device

# Path to sysfs for PCI devices
SYSFS_PCI_PATH="/sys/bus/pci/drivers"

# --- Unbind Host GPU from VFIO-PCI ---
echo "Unbinding host GPU ($HOST_GPU_PCI) from vfio-pci..."
echo "$HOST_GPU_PCI" | sudo tee "$SYSFS_PCI_PATH/vfio-pci/unbind" > /dev/null 2>&1 || true
echo "$HOST_AUDIO_PCI" | sudo tee "$SYSFS_PCI_PATH/vfio-pci/unbind" > /dev/null 2>&1 || true

# --- Load NVIDIA driver modules (if not already loaded by Xorg/display manager) ---
echo "Loading nvidia modules..."
sudo modprobe nvidia_drm
sudo modprobe nvidia_modeset
sudo modprobe nvidia

# --- Bind Host GPU to NVIDIA driver ---
echo "Binding host GPU ($HOST_GPU_PCI) to nvidia driver..."
echo "$HOST_GPU_PCI" | sudo tee "$SYSFS_PCI_PATH/nvidia/bind" > /dev/null 2>&1 || true
echo "$HOST_AUDIO_PCI" | sudo tee "$SYSFS_PCI_PATH/snd_hda_intel/bind" > /dev/null 2>&1 || true # Audio device goes to snd_hda_intel


# Optional: Restart display manager if needed (e.g., GDM, LightDM)
# sudo systemctl restart gdm3 # For GNOME
# sudo systemctl restart lightdm # For XFCE, MATE, etc.
# Check your display manager with: cat /etc/X11/default-display-manager
# --- Restart display manager ---
# This WILL cause your screen to go black momentarily and may disconnect your SSH/remote session.
# Replace 'gdm3.service' with 'lightdm.service' or 'sddm.service' if you identified a different DM.
echo "Restarting display manager..."
sudo systemctl restart gdm3.service # <--- CHANGE THIS LINE TO YOUR ACTUAL DM SERVICE
# OR if you haven't identified it specifically:
sudo systemctl restart display-manager.service

echo "Host GPU re-binding process completed."
