#!/sbin/sh
# modrd.sh initially made by Ziddey
#
# Updated for Marshmallow use by Zaclimon
#


# Check to see if there's any occurence of franco's tweaks in the ramdisk
francotweaks=`grep -c "import init.performance_profiles.rc" init.mako.rc`

# Apply performance profiles stuff
if [ $francotweaks -eq 0 ] ; then
sed '/import init.mako.tiny.rc/ a\import init.performance_profiles.rc' -i init.mako.rc
cp ../init.performance_profiles.rc ./
chmod 0755 init.performance_profiles.rc
fi

# Modifications to init.mako.rc
if [ $francotweaks -eq 0 ] ; then
sed '/scaling_governor/ s/ondemand/interactive/g' -i init.mako.rc
sed '/ondemand/ d' -i init.mako.rc

sed '/cpu3\/cpufreq\/scaling_min_freq 384000/ a\    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu0\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu1\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/cpu2\/cpufreq\/scaling_max_freq 1512000/ a\    write /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1512000' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu1/online 1' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu2/online 0' -i init.mako.rc
sed '/# disable diag port/ i\    write /sys/devices/system/cpu/cpu3/online 0' -i init.mako.rc
sed '/# disable diag port/ i\\' -i init.mako.rc
sed '/# disable diag port/ i\    # Interactive' -i init.mako.rc
sed '/# disable diag port/ i\\' -i init.mako.rc

sed '/# Interactive/ a\    restorecon_recursive /sys/devices/system/cpu/cpufreq/interactive' -i init.mako.rc
sed '/restorecon_recursive \/sys\/devices\/system\/cpu\/cpufreq\/interactive/ a\    write /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay "20000 1026000:60000 1242000:150000"' -i init.mako.rc
sed '/interactive\/above_hispeed_delay "20000 1026000:60000 1242000:150000"/ a\    write /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load 99' -i init.mako.rc
sed '/interactive\/go_hispeed_load 99/ a\    write /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq 384000' -i init.mako.rc
sed '/interactive\/hispeed_freq 384000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy 1' -i init.mako.rc
sed '/interactive\/io_is_busy 1/ a\    write /sys/devices/system/cpu/cpufreq/interactive/target_loads "90 384000:40 1026000:80 1242000:95"' -i init.mako.rc
sed '/interactive\/target_loads "90 384000:40 1026000:80 1242000:95"/ a\    write /sys/devices/system/cpu/cpufreq/interactive/min_sample_time 60000' -i init.mako.rc
sed '/interactive\/min_sample_time 60000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/timer_rate 30000' -i init.mako.rc
sed '/interactive\/timer_rate 30000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis 100000' -i init.mako.rc
sed '/interactive\/max_freq_hysteresis 100000/ a\    write /sys/devices/system/cpu/cpufreq/interactive/timer_slack 80000' -i init.mako.rc
sed '/interactive\/timer_slack 80000/ a\    # GPU' -i init.mako.rc
sed '/interactive\/timer_slack 80000/ a\\' -i init.mako.rc

sed '/# GPU/ a\    write /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk 200000000' -i init.mako.rc
sed '/kgsl-3d0\/max_gpuclk 200000000/ a\    # Mako-Hotplug' -i init.mako.rc
sed '/kgsl-3d0\/max_gpuclk 200000000/ a\\' -i init.mako.rc

sed '/# Mako-Hotplug/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/cpufreq_unplug_limit 1242000' -i init.mako.rc
sed '/mako_hotplug_control\/cpufreq_unplug_limit 1242000/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/load_threshold 75' -i init.mako.rc
sed '/mako_hotplug_control\/load_threshold 75/ a\    write /sys/devices/virtual/misc/mako_hotplug_control/high_load_counter 5' -i init.mako.rc
sed '/mako_hotplug_control\/high_load_counter 5/ a\    # I/O' -i init.mako.rc
sed '/mako_hotplug_control\/high_load_counter 5/ a\\' -i init.mako.rc

sed '/# I\/O/ a\    write /sys/block/mmcblk0/queue/nomerges 1' -i init.mako.rc
sed '/queue\/nomerges 1/ a\    write /sys/block/mmcblk0/queue/rq_affinity 2' -i init.mako.rc
sed '/queue\/rq_affinity 2/ a\    write /sys/block/mmcblk0/queue/add_random 0' -i init.mako.rc
sed '/queue\/add_random 0/ a\    write /sys/block/mmcblk0/bdi/min_ratio 5' -i init.mako.rc
sed '/bdi\/min_ratio 5/ a\    # KSM' -i init.mako.rc
sed '/bdi\/min_ratio 5/ a\\' -i init.mako.rc

sed '/# KSM/ a\    write /sys/kernel/mm/ksm/sleep_millisecs 1500' -i init.mako.rc
sed '/ksm\/sleep_millisecs 1500/ a\    write /sys/kernel/mm/ksm/pages_to_scan 256' -i init.mako.rc
sed '/ksm\/pages_to_scan 256/ a\    write /sys/kernel/mm/ksm/deferred_timer 1' -i init.mako.rc
sed '/ksm\/deferred_timer 1/ a\    write /sys/kernel/mm/ksm/run 1' -i init.mako.rc

sed '/group radio system/ a\    disabled' -i init.mako.rc
sed '/group root system/ a\    disabled' -i init.mako.rc
fi

# Modifications to init.rc
if [ $francotweaks -eq 0 ] ; then
sed '/sys\/devices\/system\/cpu\/cpufreq\/interactive/ s/0660/0664/g' -i init.rc
fi
