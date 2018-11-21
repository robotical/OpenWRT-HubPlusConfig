GL750M Install & Configure
===

Hardware Setup
---

1. You need a SD card, with a single, Linux compatible partition on it like FAT or better, EXT4.
2. Shallow Clone/copy the whole contents of this repo onto it, so that the ``www` folder is in its top level directory, like so:

        git clone git@github.com:robotical/OpenWRT-HubPlusConfig.git ./ --depth=1

3. Load the other files using the following command:

        git submodule init
        git submodule update

4. Get a copy of `scratchx` from here https://github.com/robotical/scratchx (also shallow cloned `git clone --depth=1`)

        git clone git@github.com:robotical/scratchx.git --depth=1

5. Remove the SD card from your computer and insert it into the Router
6. Turn the router on -- it'll take a couple of minutes to fully boot.
7. Whilst its booting, put a Robotical sticker on it!


Software Setup
---

1. Preferably Connect a computer using an ethernet cable, or connect to its WiFi network, `GL-AR750-___ network` password `goodlife`
2. Go to http://192.168.8.1 (the router's homepage)
3. You should see the iNet GL first time setup thingy, asking you to choose a language. No need to do anything there.
4. ssh into the router: `ssh -o StrictHostKeyChecking=no root@192.168.8.1` (There should be no root password).
In Windows, you can use PuTTY to ssh.
5. Set a root password, this can be done like so: `passwd root -d "martyrocks"`.
6. `cd` to the SD card, which is mounted at `/mnt/sda1`
7. Run the web install script: `./install-web.sh`
8. This should complete without any intervention needed. Go back to http://192.168.8.1 and check that
   * The page now shows the command hub homepage
   * The link to ScratchX works and loads the extension properly
9. Now run `./install-wifi.sh`. This will overwrite the router's wifi config, asking for a `Y` confirmation beore committing.
10. The new SSIDs and WiFi passwords are set.
11. Reboot the router and check that http://192.168.8.1 comes back up, that the SSIDs are now `martyHubPlus-5G` and `martyHubPlus-2G` adn the WiFi password `martyrocks` works. 
12. Fin!


Stuff
---

Default (factory) UCI Wireless Conf

```
wireless.radio0=wifi-device
wireless.radio0.type='mac80211'
wireless.radio0.channel='36'
wireless.radio0.hwmode='11a'
wireless.radio0.path='pci0000:00/0000:00:00.0'
wireless.radio0.htmode='VHT80'
wireless.radio0.doth='0'
wireless.radio0.txpower='20'
wireless.radio0.band='5G'
wireless.radio0.disabled='0'
wireless.default_radio0=wifi-iface
wireless.default_radio0.device='radio0'
wireless.default_radio0.network='lan'
wireless.default_radio0.mode='ap'
wireless.default_radio0.ssid='GL-AR750-194-5G'
wireless.default_radio0.encryption='psk-mixed'
wireless.default_radio0.key='goodlife'
wireless.default_radio0.ifname='wlan0'
wireless.radio1=wifi-device
wireless.radio1.type='mac80211'
wireless.radio1.channel='11'
wireless.radio1.path='platform/qca953x_wmac'
wireless.radio1.htmode='HT20'
wireless.radio1.hwmode='11ng'
wireless.default_radio1=wifi-iface
wireless.default_radio1.device='radio1'
wireless.default_radio1.network='lan'
wireless.default_radio1.mode='ap'
wireless.default_radio1.ssid='GL-AR750-194'
wireless.default_radio1.encryption='psk-mixed'
wireless.default_radio1.key='goodlife'
wireless.default_radio1.wds='1'
wireless.default_radio1.ifname='wlan1'
```

