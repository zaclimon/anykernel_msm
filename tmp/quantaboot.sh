#!/sbin/sh
#
# This script modifies /system files while installing Quanta Kernel.
#

mount -o rw /system;

# Disable the default Power HAL by renaming it's elements
 [ -e /system/lib/hw/power.msm8960.so ] && mv /system/lib/hw/power.msm8960.so /system/lib/power.msm8960.so.bak;
 [ -e /system/lib/hw/power.flo.so ] && mv /system/lib/hw/power.flo.so /system/lib/hw/power.flo.so.bak;
 [ -e /system/bin/mpdecision ] && mv /system/bin/mpdecision /system/bin/mpdecision.bak;

umount /system;
