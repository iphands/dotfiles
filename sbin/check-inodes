#!/bin/bash

IFS=$'\n'
for var in `dmesg | fgrep 'csum failed' | egrep -o 'device .* ino [0-9]{4,}'`
do
  ino=`echo $var | awk '{print $8}'`
  dev=`echo $var | awk '{print $2}'`

  echo
  echo "DEBUG: $var"
  echo "DEV: $dev INO: $ino"
  if [[ "$dev" == "sda):" ]]
  then
    btrfs inspect-internal inode-resolve $ino /mnt/STEAMLIB
  else
    btrfs inspect-internal inode-resolve $ino /
  fi
done
