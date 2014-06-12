#!/system/bin/sh

# custom busybox installation shortcut
bb=/sbin/bb/busybox;

# ensure SuperSU daemonsu/Superuser su_daemon service is running
$bb [ -e /system/xbin/daemonsu ] && /system/xbin/daemonsu --auto-daemon &
$bb [ ! -e /system/xbin/daemonsu ] &&  /system/xbin/su --daemon &

# disable sysctl.conf to prevent ROM interference with tunables
$bb mount -o rw,remount /system;
$bb [ -e /system/etc/sysctl.conf ] && $bb mv -f /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;

# disable the PowerHAL since there is a kernel-side touch boost implemented
$bb [ -e /system/lib/hw/power.msm8960.so.fkbak ] || $bb cp /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so.fkbak;
$bb [ -e /system/lib/hw/power.msm8960.so ] && $bb rm -f /system/lib/hw/power.msm8960.so;

# create and set permissions for /system/etc/init.d if it doesn't already exist
if [ ! -e /system/etc/init.d ]; then
  $bb mkdir /system/etc/init.d;
  $bb chown -R root.root /system/etc/init.d;
  $bb chmod -R 755 /system/etc/init.d;
fi;
$bb mount -o ro,remount /system;

echo 20000 1300000:40000 1400000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 85 1300000:90 1400000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads

# enable custom configuration for dt2w
$bb [ -x /sbin/dt2wconf.sh ] && /system/bin/sh /sbin/dt2wconf.sh
$bb [ -x /system/etc/init.dt2w.sh ] && /system/bin/sh /system/etc/init.dt2w.sh
