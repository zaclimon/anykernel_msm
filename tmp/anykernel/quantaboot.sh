#!/system/bin/sh
#
# Initally based from Francisco Franco's fkbootscript.sh
#

mount -o rw,remount /system;

# Disable the default Power HAL by renaming it's elements
 [ -e /system/lib/hw/power.msm8960.so ] && mv /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.bak;
 [ -e /system/bin/mpdecision ] && mv /system/bin/mpdecision /system/bin/mpdecision.bak;
 [ -e /system/lib/hw/power.mako.so ] && mv /system/lib/hw/power.mako.so /system/lib/hw/power.mako.so.bak;

# enable custom configuration for dt2w
 [ -x /sbin/dt2wconf.sh ] && /system/bin/sh /sbin/dt2wconf.sh;
 [ -x /system/etc/init.dt2w.sh ] && /system/bin/sh /system/etc/init.dt2w.sh;

mount -o ro,remount /system;
