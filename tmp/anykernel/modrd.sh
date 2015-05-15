#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Lollipop use by Zaclimon
#


# Check to see if there's any occurence of performance profile script in the ramdisk
francotweaks=`grep -c "import init.performance_profiles.rc" init.flo.rc`

# Apply performance settings stuff
if [ $francotweaks -eq 0 ] ; then
sed '/import init.flo.diag.rc/a \import init.performance_profiles.rc' -i init.flo.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.flo.rc
if [ $francotweaks -eq 0 ] ; then
sed '/on boot/ a\    write /sys/block/mmcblk0/queue/nomerges 1' -i init.flo.rc
sed '/queue\/nomerges 1/ a\    write /sys/block/mmcblk0/queue/rq_affinity 2' -i init.flo.rc
sed '/queue\/rq_affinity 2/ a\    write /sys/block/mmcblk0/queue/add_random 0' -i init.flo.rc
sed '/queue\/add_random 0/ a\    write /sys/block/mmcblk0/queue/read_ahead_kb 1024' -i init.flo.rc
sed '/queue\/read_ahead_kb 1024/ a\\' -i init.flo.rc
sed '/scaling_governor/ s/ondemand/conservative/g' -i init.flo.rc
sed '/ondemand/ d' -i init.flo.rc
sed '/cpu.notify_on_migrate/ s/1/0/g' -i init.flo.rc
sed '/group radio system/ a\    disabled' -i init.flo.rc
sed '/group root system/ a\    disabled' -i init.flo.rc
sed '/online 1/ d' -i init.flo.rc
sed '/cpu0\/cpufreq\/scaling_governor "conservative"/ i\    write /sys/devices/system/cpu/cpu1/online 1 ' -i init.flo.rc
sed '/cpu1\/online 1/ a\    write /sys/devices/system/cpu/cpu2/online 1' -i init.flo.rc
sed '/cpu2\/online 1/ a\    write /sys/devices/system/cpu/cpu3/online 1' -i init.flo.rc
fi

# Modifications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/chmod 0660 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_max_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chmod 0660 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq' -i init.rc
sed '/chmod 0660 \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_min_freq/ a\    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/chown system system \/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor a\    chmod 0660 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' -i init.rc
sed '/seclabel u:r:install_recovery:s0/d' -i init.rc
fi

# Applying some franco's stuff after boot
if [ $francotweaks -eq 0 ] ; then
echo "
on property:sys.boot_completed=1
    write /sys/block/mmcblk0/queue/scheduler noop
    write /sys/devices/system/cpu/cpufreq/conservative/input_boost_freq 1512000
    write /sys/devices/system/cpu/cpufreq/conservative/up_threshold 95
    write /sys/devices/system/cpu/cpufreq/conservative/freq_step 10
    write /sys/devices/system/cpu/cpufreq/conservative/down_threshold 40
    write /sys/class/misc/mako_hotplug_control/load_threshold 65
    write /sys/class/misc/mako_hotplug_control/high_load_counter 5 " >> init.flo.rc
fi
