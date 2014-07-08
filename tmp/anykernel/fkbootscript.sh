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

echo "20000 1350000:40000 1728000:20000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay;
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time;
echo "80 1350000:90 1512000:70" > /sys/devices/system/cpu/cpufreq/interactive/target_loads;
echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load;

echo 1 > /dev/cpuctl/apps/cpu.notify_on_migrate;
echo 2 > /sys/devices/system/cpu/sched_mc_power_savings;

