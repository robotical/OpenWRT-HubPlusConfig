#!/usr/bin/env sh
## Update script for Robotical Command Hub+

. /mnt/sda1/VERSION
echo "I       Current Version: $HUB_VERSION"

if [ ! -f /mnt/sda1/hub-update.zip ];
then
    echo "X       No Update archive found"
    exit
fi

# Verify signature
usign -V -q -m /mnt/sda1/hub-update.zip -p /mnt/sda1/.signing.pubkey

# Check return code:
if [ $? != 0 ];
then
    echo "X       =============================="
    echo "X       Signature verification Failed!"
    echo "X       ------------------------------"
    echo "X"
    echo "X       Exiting...."
    exit 1
fi

echo "I       Found an update file"

echo "I       Unpacking..."

# Check and create temp dir to unzip to
if [ ! -d /mnt/sda1/.update-files ]
then
    mkdir /mnt/sda1/.update-files
    cd /mnt/sda1/.update-files
else
    cd /mnt/sda1/.update-files
    rm -rf /mnt/sda1/.update-files/*
fi

# Unzip
unzip /mnt/sda1/hub-update.zip

echo "I       Checking if update required..."

OLD_VER=$HUB_VERSION
DIR=$(find . -type d -maxdepth 1 ! -name . | sed "s/\.\///g") # <<----- TODO bit fragile

if [ ! -d ./$DIR ];
then
    echo "X       Can't work out what dir"
    rm -rf /mnt/sda1/.update-files
    exit 2
fi

if [ ! -f /mnt/sda1/.update-files/$DIR/VERSION ];
then
    echo "X       No version number given for update, exiting..."
    rm -rf /mnt/sda1/.update-files
    exit 2
fi

# Else, continue

# Source the update's VERSION number to check for version difference
. /mnt/sda1/.update-files/$DIR/VERSION

if [[ $HUB_VERSION == $OLD_VER && $HUB_VERSION != 'master' ]];
then
    echo "I       Update is same as current version $OLD_VER"
    echo "X       Exiting...."
    rm -rf /mnt/sda1/.update-files
    exit 3
fi

echo ""
echo "--------------------------------------------------------"
echo ""

echo "I       Currently running Hub version $OLD_VER"
echo "I       New software is version $HUB_VERSION"
echo ""

echo "I       Moving files..."
mv /mnt/sda1/.update-files/* /mnt/sda1

echo ""
echo "========================================================"
echo "--------------------------------------------------------"
echo ""
echo ""

cd /mnt/sda1/$HUB_VERSION
# Perform the update:
./install.sh

echo ""
echo ""
echo "--------------------------------------------------------"
echo "========================================================"
echo ""

echo "I       Cleaning up..."
rm -rf /mnt/sda1/.update-files

# Remove update files:
rm /mnt/sda1/hub-update.zip
rm /mnt/sda1/hub-update.zip.sig

echo "Done!"
