#!/bin/sh
set -x
echo "connect 00:E5:19:57:F2:19 1" > /sys/kernel/debug/bluetooth/6lowpan_control
