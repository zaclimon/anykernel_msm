#!/system/bin/sh
#
# Initally based from Francisco Franco's fkbootscript.sh
#

# disable the PowerHAL since there is a kernel-side touch boost implemented
 [ -e /system/lib/hw/power.msm8960.so.bak ] || cp /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.bak;
 [ -e /system/lib/hw/power.msm8960.so ] && rm -f /system/lib/hw/power.msm8960.so;
 [ -e /system/bin/mpdecision ] && mv /system/bin/mpdecision /system/bin/mpdecision.bak

# enable custom configuration for dt2w
 [ -x /sbin/dt2wconf.sh ] && /system/bin/sh /sbin/dt2wconf.sh
 [ -x /system/etc/init.dt2w.sh ] && /system/bin/sh /system/etc/init.dt2w.sh
