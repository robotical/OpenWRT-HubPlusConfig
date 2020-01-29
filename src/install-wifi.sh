#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION
. ./CONFIG

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
uci set wireless.default_radio0.ssid=$HUB_SSID_5
uci set wireless.default_radio0.key=$HUB_WPA_5

uci set wireless.default_radio1.mode="ap"
uci set wireless.default_radio1.encryption="psk-mixed"
uci set wireless.default_radio1.ssid=$HUB_SSID_24
uci set wireless.default_radio1.key=$HUB_WPA_24
uci set wireless.radio1.channel='auto'
uci set wireless.radio1.txpower='23'

uci set network.lan.ipaddr=$HUB_LAN_IPADDR

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
uci commit wireless
uci commit network

echo "I   Committed changes, see uci for more "
echo "    options and current config."
echo ""

