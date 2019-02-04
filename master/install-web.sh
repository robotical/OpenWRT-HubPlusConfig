#!/usr/bin/env sh
## Install script for Robotical Command Hub+

. ./VERSION

# Stop webserver
echo "I   Stopping Service Lighttpd..."
/etc/init.d/lighttpd stop

if [ ! -d /www/ ]; then
    echo "!!!"
    echo "!!! Missing /www, exiting"
    echo "!!!"
    exit
fi

cd /www

# Check for existing files
if [ -f ./index.html ] && [ ! -f ./index.html.bkup ]; then
    echo "I   Moving exisiting index.html to index.html.bkup..."
    mv index.html index.html.bkup
fi

# add symbolic links to new web directory
echo "I   Adding symlinks in /www to /mnt/sda1/$HUB_VERSION..."

ln -s /mnt/sda1/$HUB_VERSION/www/index.html ./index.html
echo "+       Adding /www/index.html..."

ln -s /mnt/sda1/$HUB_VERSION/www/res /www/res
echo "+       Adding /www/res/..."

ln -s /mnt/sda1/$HUB_VERSION/www/tools /www/tools
echo "+       Adding /www/tools/..."

ln -s /mnt/sda1/$HUB_VERSION/scratchx /www/scratchx
echo "+       Adding /www/scratchx/..."

ln -s /mnt/sda1/$HUB_VERSION/scratch3-gui /www/scratch3
echo "+       Adding /www/scratch3/..."

if [ ! -d /scripts ]; then
    mkdir /scripts
    echo "+   Creating /scripts"
else
    echo "D   (/scripts already exists!)"
fi

echo "I       Copying list marty scripts to /scripts and /www/cgi-bin"
cp /mnt/sda1/$HUB_VERSION/parseMartys.awk /scripts/parseMartys.awk
cp /mnt/sda1/$HUB_VERSION/list-martys /www/cgi-bin/list-martys
cp /mnt/sda1/$HUB_VERSION/get-iprange /www/cgi-bin/get-iprange

echo "I   Adding Marty list script to /www/cgi-bin/list-martys"

# Change index format to match index.html
if [ -f /etc/lighttpd/lighttpd.conf ] && [ ! -f /etc/lighttpd/lighttpd.conf.backup ];
then
    echo "I   Backing up exisiting lighttpd config..."
    cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.backup
fi

echo "I   Editing /etc/lighttpd/lighttpd.conf..."
sed -i "s~index-file.names = (.*)~index-file.names = ( \"/index.html\" )~" /etc/lighttpd/lighttpd.conf

# Restart webserver
echo "I   Starting Service Lighttpd..."
/etc/init.d/lighttpd start
