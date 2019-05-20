#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION

echo ""

# Only concat the first time iff backup hasn't been made
if [ ! -f /etc/config.dhcp.backup ];
then
    echo "I   Copying /etc/config/dhcp to /etc/config.dhcp.backup"
    cp /etc/config/dhcp /etc/config.dhcp.backup
    echo "+   Concatenating ./dhcp-conf to the end of /etc/config/dhcp"
    cat ./dhcp-conf >> /etc/config/dhcp
else
    echo "!   /etc/config.dhcp.backup backup exists, assume already installed..."
fi

