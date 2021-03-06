#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION
. ./CONFIG

echo "+   Adding DNS entries to DHCP config"

uci set dhcp.dashboard=domain
uci set dhcp.dashboard.name='hub.robotical.io'
uci set dhcp.dashboard.ip=$HUB_LAN_IPADDR

uci set dhcp.scratchlink=domain
uci set dhcp.scratchlink.name='device-manager.scratch.mit.edu'
uci set dhcp.scratchlink.ip='127.0.0.1'

uci set dhcp.scratchcdn=domain
uci set dhcp.scratchcdn.name='cdn.assets.scratch.mit.edu'
uci set dhcp.scratchcdn.ip=$HUB_LAN_IPADDR

uci set dhcp.scratchmain=domain
uci set dhcp.scratchmain.name='scratch.mit.edu'
uci set dhcp.scratchmain.ip=$HUB_LAN_IPADDR

uci commit dhcp

