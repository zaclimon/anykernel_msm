#!/system/bin/sh

# disable sysctl.conf to prevent ROM interference with tunables
mount -o rw,remount /system;
[ -e /system/etc/sysctl.conf ] && mv -f /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;

# disable the PowerHAL since there is a kernel-side touch boost implemented
[ -e /system/lib/hw/power.msm8960.so.fkbak ] || cp /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.fkbak;
[ -e /system/lib/hw/power.msm8960.so ] && rm -f /system/lib/hw/power.msm8960.so;

# create and set permissions for /system/etc/init.d if it doesn't already exist
if [ ! -e /system/etc/init.d ]; then
   mkdir /system/etc/init.d;
   chown -R root.root /system/etc/init.d;
   chmod -R 755 /system/etc/init.d;
fi;
 mount -o ro,remount /system;

# enable custom configuration for dt2w
 [ -x /sbin/dt2wconf.sh ] && /system/bin/sh /sbin/dt2wconf.sh
 [ -x /system/etc/init.dt2w.sh ] && /system/bin/sh /system/etc/init.dt2w.sh

# execute the otg control script
[ -x /system/etc/otgcontrol.sh ] && /system/bin/sh /system/etc/otgcontrol.sh
