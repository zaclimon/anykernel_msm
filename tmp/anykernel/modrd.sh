#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Edits the target device's init scripts according to the desired modification
# Updated for Marshmallow use by Zaclimon
#


# Check to see if there's any occurence of the performance profile script in the ramdisk
francotweaks=`grep -c "import init.performance_profiles.rc" init.flo.rc`

# Apply performance settings stuff
if [ $francotweaks -eq 0 ] ; then
sed '/import init.flo.diag.rc/a \import init.performance_profiles.rc' -i init.flo.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.flo.rc
if [ $francotweaks -eq 0 ] ; then
sed '/scaling_governor/ s/ondemand/interactive/g' -i init.flo.rc
sed '/ondemand/ d' -i init.flo.rc

sed '/cpu3\/cpufreq\/scaling_min_freq 384000/ a\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1512000' -i init.flo.rc
sed '/cpu0\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1512000' -i init.flo.rc
sed '/cpu1\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1512000' -i init.flo.rc
sed '/cpu2\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1512000' -i init.flo.rc
sed '/cpu3\/online 1/ a\    # Interactive' -i init.flo.rc
sed '/cpu3\/online 1/ a\\' -i init.flo.rc

sed '/# Interactive/ a\    restorecon_recursive /sys/devices/system/cpu/cpufreq/interactive' -i init.flo.rc
sed '/restorecon_recursive \/sys\/devices\/system\/cpu\/cpufreq\/interactive/ a\    write /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay "20000 1026000:60000 1242000:150000"' -i init.flo.rc
sed '/interactive\/above_hispeed_delay "20000 1026000:60000 1242000:150000"/ a\    write /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load 99' -i init.flo.rc
sed '/interactive\/go_hispeed_load 99/ a\    write /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq 384000' -i init.flo.rc
sed '/interactive\/hispeed_freq 384000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy 1' -i init.flo.rc
sed '/interactive\/io_is_busy 1/ a\    write /sys/devices/system/cpu/cpufreq/interactive/target_loads "90 384000:40 1026000:80 1242000:95"' -i init.flo.rc
sed '/interactive\/target_loads "90 384000:40 1026000:80 1242000:95"/ a\    write /sys/devices/system/cpu/cpufreq/interactive/min_sample_time 60000' -i init.flo.rc
sed '/interactive\/min_sample_time 60000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/timer_rate 30000' -i init.flo.rc
sed '/interactive\/timer_rate 30000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis 100000' -i init.flo.rc
sed '/interactive\/max_freq_hysteresis 100000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/timer_slack 30000' -i init.flo.rc
sed '/interactive\/timer_slack 30000/ a\\' -i init.flo.rc

sed '/cpu.notify_on_migrate/ i\    # Sched' -i init.flo.rc
sed '/cpu.notify_on_migrate/ s/1/0/g' -i init.flo.rc
sed '/cpu.notify_on_migrate/ a\    # Mako-Hotplug' -i init.flo.rc
sed '/cpu.notify_on_migrate/ a\\' -i init.flo.rc

sed '/# Mako-Hotplug/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/cpufreq_unplug_limit 1242000' -i init.flo.rc
sed '/mako_hotplug_control\/cpufreq_unplug_limit 1242000/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/load_threshold 75' -i init.flo.rc
sed '/mako_hotplug_control\/load_threshold 75/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/high_load_counter 5' -i init.flo.rc
sed '/mako_hotplug_control\/high_load_counter 5/ a\    # I/O' -i init.flo.rc
sed '/mako_hotplug_control\/high_load_counter 5/ a\\' -i init.flo.rc

sed '/# I\/O/ a\    write /sys/block/mmcblk0/queue/nomerges 1' -i init.flo.rc
sed '/queue\/nomerges 1/ a\    write /sys/block/mmcblk0/queue/rq_affinity 2' -i init.flo.rc
sed '/queue\/rq_affinity 2/ a\    write /sys/block/mmcblk0/queue/add_random 0' -i init.flo.rc
sed '/queue\/add_random 0/ a\    write /sys/block/mmcblk0/bdi/min_ratio 5' -i init.flo.rc
sed '/bdi\/min_ratio 5/ a\    # KSM' -i init.flo.rc
sed '/bdi\/min_ratio 5/ a\\' -i init.flo.rc

sed '/# KSM/ a\    write /sys/kernel/mm/ksm/sleep_millisecs 1500' -i init.flo.rc
sed '/ksm\/sleep_millisecs 1500/ a\    write /sys/kernel/mm/ksm/pages_to_scan 256' -i init.flo.rc
sed '/ksm\/pages_to_scan 256/ a\    write /sys/kernel/mm/ksm/deferred_timer 1' -i init.flo.rc
sed '/ksm\/deferred_timer 1/ a\    write /sys/kernel/mm/ksm/run 1' -i init.flo.rc

sed '/group radio system/ a\    disabled' -i init.flo.rc
sed '/group root system/ a\    disabled' -i init.flo.rc
fi

# Modifications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/sys\/devices\/system\/cpu\/cpufreq\/interactive/ s/0660/0664/g' -i init.rc
fi
