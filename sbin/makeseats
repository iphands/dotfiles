#!/bin/bash
set -e

attach() {
    var="$1"
    seat="$2"
    echo "Attaching to ${seat}: $var"
    loginctl attach "$seat" "$var"
}

gpu="`lspci | fgrep -m1 970 | cut -d: -f1`"
echo $gpu

for var in `find /sys/devices | fgrep devices/pci | fgrep 0000:${gpu} | grep card1$`
do
    attach $var seat1
done

# for var in /sys/bus/usb/devices/*
for var in `find /sys/devices/pci0000\:00 -type d | grep usb[0-9]`
do
    [[ -f "${var}/idVendor" ]] || continue
    ID="`cat ${var}/idVendor`:`cat ${var}/idProduct`" || true
    # echo "DEBUG: $ID $var"
    [[ "$ID" == "413c:1001" ]] && attach $var seat1
    [[ "$ID" == "413c:2001" ]] && attach $var seat1
    [[ "$ID" == "260d:1014" ]] && attach $var seat1
done

# for var in `loginctl seat-status seat0 | fgrep pci0000:00/0000:00:08.1 | fgrep usb | grep -o '/sys/devi.*'`
# do
#   attach $var seat1
# done

for var in `loginctl seat-status seat0 | fgrep 'E-Signal USB Gaming Mouse' -B1 | grep -o '/sys/devi.*'`
do
    attach $var seat1
done

for var in `loginctl seat-status seat0 | fgrep 'Dell' -B1 | grep -o '/sys/devi.*'`
do
    attach $var seat1
done

for var in `loginctl seat-status seat0 | fgrep -i "nvidia hdmi" -b1 | fgrep 0b:00 | grep -o '/sys/devices.*'`
do
  attach $var seat1
done


# for var in `loginctl seat-status seat1 | grep -o '/sys/devi.*'`
# do
#     #attach $var seat0
# done
