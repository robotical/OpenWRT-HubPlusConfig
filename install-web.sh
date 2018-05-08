#!/usr/bin/env sh
## Install script for Robotical Command Hub+

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
if [ -f ./index.html ]; then
    echo "I   Moving exisiting index.html to index.html.bkup..."
    mv index.html index.html.bkup
fi

# add symbolic links to new web directory
echo "I   Adding symlinks in /www to /mnt/sda1..."

ln -s /mnt/sda1/www/index.html ./index.html
echo "+       Adding /www/index.html..."

if [ ! -d /www/res ]; then
    ln -s /mnt/sda1/www/res /www/res
    echo "+       Adding /www/res/..."
else
    echo "D       (/www/res/ already exists)"
fi
if [ ! -d /www/scratchx ]; then
    ln -s /mnt/sda1/scratchx /www/scratchx
    echo "+       Adding /www/scratchx/..."
else
    echo "D       (/www/scratchx/ already exists)"
fi

# Change index format to match index.html
if [ ! -f /etc/lighttpd/lighttpd.conf ]; then
    echo "I   Backing up exisiting lighttpd config..."
    cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.backup
fi

echo "I   Editing /etc/lighttpd/lighttpd.conf..."
sed -i "s~index-file.names = (.*)~index-file.names = ( \"/index.html\" )~" /etc/lighttpd/lighttpd.conf

# Restart webserver
echo "I   Starting Service Lighttpd..."
/etc/init.d/lighttpd start
