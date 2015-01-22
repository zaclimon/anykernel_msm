#!/system/bin/sh
#
# This script controls the various patches implemented by Timur in his kernel
#
# All credits goes to Timur Mehrvarz
# https://github.com/mehrvarz
#
# Modified for SM-Franco use by zaclimon
#


# usbhost_charge_slave_devices (Number of devices used for usbhost + charging.)
echo "0" > /sys/kernel/usbhost/usbhost_charge_slave_devices

# usbhost_fastcharge_in_host_mode (Enables fastcharge in usb host mode. 1 to enable, 0 to disable)
echo "0" > /sys/kernel/usbhost/usbhost_fastcharge_in_host_mode

# usbhost_firm_sleep (enables firm sleep while in usb host mode. 1 to enable, 0 to disable)
echo "0" > /sys/kernel/usbhost/usbhost_firm_sleep

# usbhost_fixed_install_mode (enables FI mode while in usb host mode. 1 to enable, 0 to disable)
echo "0" > /sys/kernel/usbhost/usbhost_fixed_install_mode

# usbhost_hostmode (enables/disables usb host mode. 0 for regular operation, 1 for host mode)
echo "0" > sys/kernel/usbhost/usbhost_hostmode

# usbhost_hotplug_on_boot (Permits usb DAC on boot. 1 to enable, 0 to disable)
echo "0" > /sys/kernel/usbhost/usbhost_hotplug_on_boot

# usbhost_lock_usbdisk (Can activate virtual mount during a power loss, 1 to enable, 0 to disable)
echo "0" > /sys/kernel/usbhost/usbhost_hotplug_on_boot
