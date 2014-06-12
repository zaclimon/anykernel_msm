#! /system/bin/sh
#
# Set DT2W tunables according to a configuration file.
# http://lilotux.net/~mikael/pub/android/kernel/N4/
# https://github.com/McKael/FrancoKernel-mako/
# Mikael Berthe, 2014-05-26

CONF="/sdcard/dt2w.conf"
LGE_T_DIR="/sys/module/lge_touch_core/parameters"

[ -r $CONF ] || exit 0

cd ${LGE_T_DIR} || exit 1

for f in double*; do
    if grep -E "^$f=[0-9YN]+\$" $CONF > /dev/null; then
        l=$(grep -E "^$f=[0-9YN]+\$" $CONF)
        v=${l/*=/}
        echo "Setting $f to $v"
        echo $v > $f
    fi
done
