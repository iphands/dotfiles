#!/bin/bash
set -e
source ~/.ipmi_pass

ipmi() {
  time ipmitool -I lanplus -U root -P "$PASS" -H noir-idrac.lan raw 0x30 0x30 0x01 0x0
  time ipmitool -I lanplus -U root -P "$PASS" -H noir-idrac.lan raw 0x30 0x30 0x02 0xff $1
}

# ipmi 0x60 # almost max
# ipmi 0x3e # safe 32-core-load 85C
# ipmi 0x26 # safe-16-core-load 85C
ipmi 0x1b # safe-04-core-load 85C
## ipmi 0x17 # slow
## ipmi 0x12 # idle
