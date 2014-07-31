#!/sbin/sh
# modrd.sh by ziddey
# attempts to apply franco's ramdisk mods to any ramdisk
# based on diff of factory krt16s ramdisk vs franco
# with check/mod for init.cm.rc

# Copy the busybox specified in the fkbootscript.sh if not present
if [ ! -d sbin/bb ] ; then
cp -r ../bb/ sbin/
fi

# Copy franco's tweaks as well as the dt2w config script
cp ../fkbootscript.sh sbin/
cp ../dt2wconf.sh sbin/

# Add permissions to be executable
chmod 0750 sbin/bb/busybox
chmod 0750 sbin/fkbootscript.sh
chmod 0750 sbin/dt2wconf.sh

# Check to see if there's any occurence of the fkbootscript service into init.mako.rc
fkbootdetect=`grep -c "fkbootscript.sh" init.mako.rc`

# Disable the thread migration if present
threadmigration=`grep -c "write /dev/cpuctl/apps/cpu.notify_on_migrate 1" init.mako.rc`

# init.mako.rc
sed "/#/! {/dev\/socket\/mpdecision/ s/^    /    #/g}" -i init.mako.rc
sed "/vibrator/ s/70/100/g" -i init.mako.rc
sed "/^on charger/,/^on / {/write/d}" -i init.mako.rc
sed "/scaling_governor/ s/ondemand/interactive/g" -i init.mako.rc
sed "/ondemand/ d" -i init.mako.rc

sed "/cpu3\/cpufreq\/scaling_min_freq/,/on charger/ {/online/ d}" -i init.mako.rc
sed "/cpu3\/cpufreq\/scaling_min_freq/ a\\
    write /sys/devices/system/cpu/cpu1/online 1\\
    write /sys/devices/system/cpu/cpu2/online 1\\
    write /sys/devices/system/cpu/cpu3/online 1" -i init.mako.rc

# must use /class/ since +1 doesn't work with busybox sed:
sed "/#/! {/service thermald/,/class/ s/^/#/g}" -i init.mako.rc
sed "/#/! {/service mpdecision/,/class/ s/^/#/g}" -i init.mako.rc

sed "/start diag_mdlog/,/notify_on_migrate/ {/start diag_mdlog/! d}" -i init.mako.rc
#sed "/gsm.sim.state=READY/ i\\

if [ $fkbootdetect -eq 0 ] ; then
echo "
service fkbootscript /sbin/fkbootscript.sh
    class late_start
    user root
    disabled
    oneshot

on property:sys.boot_completed=1
    start fkbootscript
    write /dev/cpuctl/apps/cpu.notify_on_migrate 0" >> init.mako.rc
fi

if [ $threadmigration -eq 1 ] ; then
sed "s/cpu.notify_on_migrate 1/ cpu.notify_on_migrate 0/g" -i init.mako.rc
fi

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
