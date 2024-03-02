#!/bin/bash
set -e

cd /root/ffxiv-iphands
md5sum * >/tmp/ffxiv.iphands.md5sums &

cd /root/ffxiv-merozas
md5sum * >/tmp/ffxiv.merozas.md5sums &

time wait
diff -uw /tmp/ffxiv.merozas.md5sums /tmp/ffxiv.iphands.md5sums
