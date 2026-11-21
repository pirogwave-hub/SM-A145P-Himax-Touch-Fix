#!/system/bin/sh

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

sleep 3

ATTEMPTS=0
while [ ! -e "/sys/bus/spi/drivers/himax_tp/spi2.0" ] && [ "$ATTEMPTS" -lt 20 ]; do
    if [ ! -d "/sys/bus/spi/drivers/himax_tp" ]; then
        KO_PATH=$(find /vendor/lib/modules /lib/modules -name "*himax*" 2>/dev/null | head -n 1)
        [ -n "$KO_PATH" ] && insmod "$KO_PATH" 2>/dev/null
        sleep 1
    fi

    echo "spi2.0" > /sys/bus/spi/drivers/himax_tp/unbind 2>/dev/null
    sleep 1
    echo "spi2.0" > /sys/bus/spi/drivers/himax_tp/bind 2>/dev/null

    if [ -e "/sys/bus/spi/drivers/himax_tp/spi2.0" ]; then
        break
    fi

    ATTEMPTS=$((ATTEMPTS + 1))
    sleep 2
done
