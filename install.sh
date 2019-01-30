#!/usr/bin/env sh
## Install script for Robotical Command Hub+

if [ ! -f /etc/init.d/robotical-check-update ];
then
    cp /mnt/sda1/robotical-check-update /etc/init.d/robotical-check-update
    chmod +x /etc/init.d/robotical-check-update
    /etc/init.d/robotical-check-update enable
fi

./install-web.sh
yes Y | ./install-wifi.sh

