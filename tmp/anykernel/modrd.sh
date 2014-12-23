#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Lollipop use by Zaclimon
#


# Check to see if there's any occurence of performance profile script in the ramdisk
performanceprofiles=`grep -c "import init.performance_profiles.rc" init.flo.rc`

# Detect the presence of franco's tweaks into init.flo.rc
francotweaks=`grep -c "on property:sys.boot_completed=1" init.flo.rc`


# Copy franco's boot script
cp ../fkbootscript.sh sbin/

# Add permissions to be executable
chmod 0750 sbin/fkbootscript.sh

# Apply performance settings stuff
if [ $performanceprofiles -eq 0 ] ; then
sed '/import init.flo.diag.rc/a \import init.performance_profiles.rc' -i init.flo.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.flo.rc
if [ $francotweaks -eq 0 ] ; then
sed '/scaling_governor/ s/ondemand/interactive/g' -i init.flo.rc
sed '/ondemand/d' -i init.flo.rc
sed '/cpu.notify_on_migrate /s/1/0/g' -i init.flo.rc
sed '/group radio system/a \    disabled' -i init.flo.rc
sed '/group root system/a \    disabled' -i init.flo.rc
fi

# Modifications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/sys\/devices/ s/0660/0664/g' -i init.rc
sed '/chmod 0664 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_max_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chmod 0664 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor a\    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/seclabel u:r:install_recovery:s0/d' -i init.rc
fi

# Applying some franco's stuff after boot
if [ $francotweaks -eq 0 ] ; then
echo "
service fkbootscript /sbin/fkbootscript.sh
    class late_start
    user root
    disabled
    oneshot

on property:sys.boot_completed=1
    start fkbootscript
    write /sys/block/mmcblk0/queue/scheduler deadline
    write /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay "20000 800000:40000 1300000:20000"
    write /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load 90
    write /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq 1134000
    write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy 1
    write /sys/devices/system/cpu/cpufreq/interactive/target_loads "85 800000:90 1300000:70"
    write /sys/devices/system/cpu/cpufreq/interactive/min_sample_time "40000 1200000:80000"
    write /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor 100000
    write /sys/devices/system/cpu/cpufreq/interactive/input_boost_freq 1134000
    write /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis 100000 " >> init.flo.rc
fi
