#!/bin/bash

# Define PCI addresses
GUEST_GPU="86:00.0"
GUEST_AUDIO="86:00.1"
HOST_GPU="18:00.0"
HOST_AUDIO="18:00.1"

echo "=== [1] GPU Device Bindings ==="
for dev in $HOST_GPU $HOST_AUDIO $GUEST_GPU $GUEST_AUDIO; do
    echo -n "$dev is bound to: "
    DRIVER=$(readlink -f /sys/bus/pci/devices/0000:$dev/driver 2>/dev/null)
    if [[ -n "$DRIVER" ]]; then
        echo "${DRIVER##*/}"
    else
        echo "No driver (unbound)"
    fi
done

echo ""
echo "=== [2] Kernel Modules ==="
echo -n "VFIO modules loaded: "
lsmod | grep -E '^vfio|vfio_pci' || echo "❌ Not loaded"

if [ -d /sys/module/vfio_pci ]; then
  echo "✅ vfio-pci built-in and active"
else
  echo "❌ vfio-pci not active"
fi

echo -n "KVM modules loaded: "
lsmod | grep -E '^kvm' || echo "❌ Not loaded"
echo -n "NVIDIA driver in use: "
lsmod | grep -E '^nvidia' || echo "❌ Not loaded"
echo -n "Nouveau present: "
lsmod | grep nouveau && echo "⚠️ WARNING: nouveau loaded!" || echo "✅ Not loaded"

echo ""
echo "=== [3] IOMMU Status ==="
dmesg | grep -i -e iommu -e DMAR | grep -i "enabled"

echo ""
echo "=== [4] vfio-pci Driver Bindings ==="
echo "Devices under /sys/bus/pci/drivers/vfio-pci:"
ls -l /sys/bus/pci/drivers/vfio-pci | grep 0000: || echo "❌ No devices bound"

echo ""
echo "=== [5] lspci Summary ==="
lspci -nnk | grep -A 3 -i nvidia

