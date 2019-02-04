GL750M Install & Configure
===

Hardware Setup for Development Code
-----------------------------------

1. You need a SD card, with a single, Linux compatible partition on it like FAT or better, EXT4.
2. Open a terminal and change directory to the SD card.
3. Shallow Clone/copy the whole contents of this repo onto it, so that the `master` folder is in its
   top level directory, like so:

        git clone git@github.com:robotical/OpenWRT-HubPlusConfig.git ./ --depth=1 --recurse-submodules

4. Unmount then Remove the SD card from your computer and insert it into the Router.
5. Turn the router on -- it'll take a couple of minutes to fully boot. You can tell it has booted
   when all three front LEDs are lit.
6. Whilst it is booting, put a Robotical sticker on it!


Software Setup
--------------

1. Preferably Connect a computer using an ethernet cable, or connect to its WiFi network,
   `GL-AR750-___ network` password `goodlife`
2. Go to http://192.168.8.1 (the router's homepage)
3. You should see the iNet GL first time setup thingy, asking you to choose a language. No need
   to do anything there.
4. ssh into the router: `ssh -o StrictHostKeyChecking=no root@192.168.8.1` (There should be no
   root password). In Windows, you can use PuTTY to ssh.
5. **Set a root password**, this can be done like so: `passwd root -d "martyrocks"`.
6. `cd` to the SD card, which is mounted at `/mnt/sda1`
6. `cd` to main directory, which is at `/mnt/sda1/master` or `/mnt/sda1/<version>` for a release.
7. Run the web install scripts: `./install.sh`.  This will overwrite the router's wifi config,
   asking for a `Y` confirmation before committing.
8. Go back to http://192.168.8.1 and check that
   * The page now shows the command hub homepage
   * The link to ScratchX works and loads the extension properly
9. The new SSIDs and WiFi passwords are set.
10. Reboot the router and check that http://192.168.8.1 comes back up, that the SSIDs are now
    `martyHubPlus-5G` and `martyHubPlus-2G` and the WiFi password `martyrocks` works. 
11. Fin!


Using your Hub
--------------

You should usually use the hub in an **air gapped** manner, meaning it is not connected to the Internet
and just presents a WiFi network.

Alternatively, you can **connect the Hub to the internet** using an Ethernet cable into the **WAN** port
(shown with a little Globe Icon), or via USB tethering through the USB-A port (this seems to work with
some but not all dongles or phones)

You may need or access the *OpenWRT* config page on the router, at
[`http://192.168.8.1/cgi-bin/luci`](http://192.168.8.1/cgi-bin/luci)

If you want to connect your Hub to the Internet, we **strongly** recommend that you first:

1. Change the WiFi password from the default `martyrocks`
2. Change the SSH password too
3. Treat the Hub and the Hub's WiFi network with the same level of scritiny and security
   conscientiousness you would your own home router.

If using the Hub in a **Networked manner**, you can then use the 'normal' Scratch and Marty Programming
interfaces instead of the included ones. These online interfaces are more likely to be up-to-date.

The Hub also offers many other configuration options, including VPN, UoPnP, USB Storage Sharing and
DDNS support.

**If you connect your Hub to a newtork** you *must* ensure you have secured its config, changed its
password and are comfortable + understand that the hub could, if miscounfigured, cause problems.


Updating your Command Hub (Normal Edition)
------------------------------------------

Turn off the Hub, remove the SD card and insert it in to a computer. Copy the update files onto
the SD card:

       /hub-update.zip
       /hub-update.zip.sig
       /update.sh

Then simply pop it back in the Hub and turn it back on. It should install the update on boot.


Updating your Command Hub (Development Edition)
-----------------------------------------------

You can check what version of Hub software you're running by running `. /mnt/sda1/VERSION` on the hub.

1. Remove the SD card from the Hub and plug it in to an internet-connected computer
2. Change to the SD card top-level directory. 
3. Run the following command to fetch latest files:

        git pull origin master --recurse-submodules

    This will fetch the latest version of
    [this repository](https://github.com/robotical/OpenWRT-HubPlusConfig)
    and the linked Submodules (currently Scratch)
4. If on a computer, eject the card, add it back to the hub and reboot, SSH in to it, `cd /mnt/sda1`
4. Run the update script: `./update.sh`


Making a Release
----------------

This is very similar to just cloning the repo, but with extra steps!

1. Test that the hub works with this exact set of files! Do a full reset and install.
2. Change `./VERSION` and increment the version number within. Take note of what the number is...
3. Do what you can re. making updates painless, see `update.sh`
4. Now make a new git tag with *just* the version number (1.1.0 shown as an example):

        git tag 1.1.0

5. Push this tag to `origin`

        git push origin --tags

6. This will add the tag on GitHub. Go find the tag, and open up the tag editor so we can turn
   it in to a GithUb release. Sadly the auto-generated source zips *won't* include the Git Submodules
   so a few steps are needed to make a working downloadable zip.
7. To do this, run the `makerelease.sh` script:

        ./makerelease.sh

   It will ask you to enter the version number and will then put together a release zip.

8. Now go look at "Signing the Release" so you can put together a full release.


Signing the Release!
--------------------

***Note to the Causal Reader:** There's a private key that we have that for obvious
reasons won't be shared... You can make your own by typing the following into a terminal
on the Hub* `usign -G -p ./.signing.pubkey -s ./.signing.secret`. *Obviously, don't share it.*


You have to do this bit from the command line on a hub, so as to have access to the `usign`
utility. With the zip file copied onto the Hub, rename it to `hub-update.zip`:

```
$ cd /mnt/sda1/
$ mv OpenWRT-HubPlusConfig-0.0.0.zip hub-update.zip
#                          ^^^ Replace with correct here
```

Then create a signature (this will take approx. 10 seconds) and then verify that it
works good (another 10s or so):

```
$ usign -S -m ./hub-update.zip -s ./.signing.secret
$ usign -V -m ./hub-update.zip -p ./.signing.pubkey
```

This will make a new file called `hub-update.zip.sig` which is the signature you need!
Remember, you'll need to re-sign if you make *any* change to the zip.

It's easiest to then just turn the hub off and copy these over.


Stuff
---

#### Resetting a Hub

Default (factory) UCI Wireless Conf.

You can factory reset the hub by holding the reset button down (looks like a circular arrow)
for 15 seconds, until it starts flashing really quickly, then releasing.

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

