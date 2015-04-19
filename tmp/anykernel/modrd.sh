#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Lollipop use by Zaclimon
#


# Check to see if there's any occurence of any of franco's tweaks in the ramdisk
francotweaks=`grep -c "import init.performance_profiles.rc" init.mako.rc`

# Copy quanta boot script
cp ../quantaboot.sh sbin/

# Add permissions to be executable
chmod 0750 sbin/quantaboot.sh

# Apply performance profiles stuff
if [ $francotweaks -eq 0 ] ; then
sed '/import init.mako.tiny.rc/ a\import init.performance_profiles.rc' -i init.mako.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.mako.rc
if [ $francotweaks -eq 0 ] ; then
sed '/scaling_governor/ s/ondemand/conservative/g' -i init.mako.rc
sed '/ondemand/d' -i init.mako.rc
sed '/cpu.notify_on_migrate /s/1/0/g' -i init.mako.rc
sed '/group radio system/ a\    disabled' -i init.mako.rc
sed '/group root system/ a\    disabled' -i init.mako.rc
sed '/cpu0\/cpufreq\/scaling_governor "conservative"/ i\    write /sys/devices/system/cpu/cpu1/online 1 ' -i init.mako.rc
sed '/cpu1\/online 1/ a\    write /sys/devices/system/cpu/cpu2/online 1' -i init.mako.rc
sed '/cpu2\/online 1/ a\    write /sys/devices/system/cpu/cpu3/online 1' -i init.mako.rc
fi

# Modidfications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/sys\/devices/ s/0660/0664/g' -i init.rc
sed '/chmod 0664 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_max_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chmod 0664 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor a\    chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/seclabel u:r:install_recovery:s0/d' -i init.rc
fi

# Applying franco's stuff after boot
if [ $francotweaks -eq 0 ] ; then
echo "
service quantaboot /sbin/quantaboot.sh
    class late_start
    user root
    disabled
    oneshot

on property:sys.boot_completed=1
    start quantaboot
    write /sys/block/mmcblk0/queue/scheduler noop
    write /sys/devices/system/cpu/cpufreq/conservative/input_boost_freq 1512000
    write /sys/devices/system/cpu/cpufreq/conservative/up_threshold 95
    write /sys/devices/system/cpu/cpufreq/conservative/freq_step 10
    write /sys/devices/system/cpu/cpufreq/conservative/down_threshold 40
    write /sys/class/misc/mako_hotplug_control/load_threshold 65
    write /sys/class/misc/mako_hotplug_control/high_load_counter 5 " >> init.mako.rc
fi
