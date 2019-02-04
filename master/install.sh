#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION

# Copy version over
cp /mnt/sda1/$HUB_VERSION/VERSION /mnt/sda1/VERSION

# Install init.d auto-update scipt
cp /mnt/sda1/$HUB_VERSION/robotical-check-update /etc/init.d/robotical-check-update
chmod +x /etc/init.d/robotical-check-update
/etc/init.d/robotical-check-update enable

# Run other install scripts
./install-web.sh
yes Y | ./install-wifi.sh

