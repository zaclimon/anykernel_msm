#!/sbin/sh
# modrd.sh by ziddey
# attempts to apply franco's ramdisk mods to any ramdisk
# based on diff of mako's factory krt16s ramdisk vs franco
# with check/mod for init.cm.rc
# Modified for Flo use by zaclimon

# Copy the busybox specified in the fkbootscript.sh if not present
if [ ! -d sbin/bb ] ; then
cp -r ../bb/ sbin/
fi

# Copy franco's tweaks
cp ../fkbootscript.sh sbin/

# Add permissions to be executable
chmod 0750 sbin/bb/busybox
chmod 0750 sbin/fkbootscript.sh

# init.mako.rc
sed "/#/! {/dev\/socket\/mpdecision/ s/^    /    #/g}" -i init.flo.rc
sed "/^on charger/,/^on / {/write/d}" -i init.flo.rc
sed "/scaling_governor/ s/ondemand/interactive/g" -i init.flo.rc
sed "/ondemand/ d" -i init.flo.rc

sed "/cpu3\/cpufreq\/scaling_min_freq/,/on charger/ {/online/ d}" -i init.flo.rc
sed "/cpu3\/cpufreq\/scaling_min_freq/ a\\
    write /sys/devices/system/cpu/cpu1/online 1\\
    write /sys/devices/system/cpu/cpu2/online 1\\
    write /sys/devices/system/cpu/cpu3/online 1" -i init.flo.rc

# must use /class/ since +1 doesn't work with busybox sed:
sed "/#/! {/service thermald/,/class/ s/^/#/g}" -i init.flo.rc
sed "/#/! {/service mpdecision/,/class/ s/^/#/g}" -i init.flo.rc

echo "
service fkbootscript /sbin/fkbootscript.sh
    class late_start
	user root
	disabled
        oneshot

on property:sys.boot_completed=1
	start fkbootscript
	write /dev/cpuctl/apps/cpu.notify_on_migrate 1" >> init.flo.rc


# init.rc
sed "/randomize_va_space/ s/2/0/g" -i init.rc

[ -f init.cm.rc ] && sed "/ondemand/ d" -i init.cm.rc
#sed "/sys\/devices/ s/0660/0664/g" -i init.rc
#if [ -e init.cm.rc ]; then
#	sed "/sys\/devices/ s/0660/0664/g" -i init.cm.rc
#else # cm should already have the following...
#grep -q "scaling_governor" init.rc || sed "/chmod.*scaling_max_freq/ a\\
#	chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq\\
#    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq\\
#	chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor\\
#    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" -i init.rc
#fi
