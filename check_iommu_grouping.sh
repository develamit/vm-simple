#!/bin/bash

shopt -s nullglob
for d in /sys/kernel/iommu_groups/*/devices/*; do
    nuke="not";
    if [[ $(basename $(readlink -f $d/driver)) == "nvidia" ]]; then nuke="yes"; fi;
    printf "IOMMU Group %s %s\n" "$(basename "$(dirname "$d")")" "$(basename "$d")";
    lspci -nns $(basename "$d");
done | sort -V


#for d in /sys/kernel/iommu_groups/*/devices/*; do
    #echo "$(basename $(dirname $d)) -> $(basename $d)"
#done | sort -n

