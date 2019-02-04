#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION

echo ""
echo "========================================================"
echo ""
echo "I   Current WRT (UCI) settings:"
echo ""

uci show wireless

echo ""
uci show wireless > ~/uci-wireless-backup.txt
echo "I       Copy Saved as ~/uci-wireless-backup.txt"
echo "I   Configuring WiFi..."

uci set wireless.radio0.band="5G"
uci set wireless.default_radio0.mode="ap"
uci set wireless.default_radio0.encryption="psk-mixed"
uci set wireless.default_radio0.ssid="RoboticalHubPlus-5G"
uci set wireless.default_radio0.key="martyrocks"

uci set wireless.default_radio1.mode="ap"
uci set wireless.default_radio1.encryption="psk-mixed"
uci set wireless.default_radio1.ssid="RoboticalHubPlus-2G"
uci set wireless.default_radio1.key="martyrocks"

uci set network.lan.ipaddr="192.168.8.1"

echo ""
echo "========================================================"
echo ""
echo "I   Config Changes:  (Hub $HUB_VERSION)"
echo ""
uci changes

echo ""
echo "--------------------------------------------------------"
echo ""

read -p "!   Press Y to Confirm and Commit Changes, N to Cancel: " -n 1 -r
echo ""
if [ ! $REPLY == "Y" ]
then
    uci revert wireless
    echo "I   Aborted, exiting..."
    exit 1
fi

# save changes
uci commit

echo "I   Committed changes, see uci for more "
echo "    options and current config."
echo ""

