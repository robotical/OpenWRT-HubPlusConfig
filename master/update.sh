#!/usr/bin/env sh
## Update script for Robotical Command Hub+

echo "Current Version:"
. /mnt/sda1/VERSION

if [ ! -f /mnt/sda1/hub-update.zip ];
then
    echo "X       No Update archive found!"
    exit 1
fi

# Verify signature
usign -V -q -m /mnt/sda1/hub-update.zip -p /mnt/sda1/signing.pubkey

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

# Check and create dir
if [ ! -d /mnt/sda1/.update-files ]
then
    mkdir /mnt/sda1/.update-files
    cd /mnt/sda1/.update-files
else
    cd /mnt/sda1/.update-files
    rm -rf /mnt/sda1/.update-files/*
fi

# Unpack
#tar xf /mnt/sda1/hub-update
unzip /mnt/sda1/hub-update.zip

echo "I       Checking if update required..."

OLD_VER=$HUB_VERSION

if [ ! -f /mnt/sda1/.update-files/VERSION ];
then
    echo "X       No version number given for update, exiting..."
    rm -rf /mnt/sda1/.update-files
    exit 2
fi

# Else, continue

# Source the update's VERSION number to check version difference
. /mnt/sda1/.update-files/VERSION

if [[ $HUB_VERSION == $OLD_VER && $HUB_VERSION != 'master' ]];
then
    echo "I       Update is same as current version $OLD_VER"
    echo "X       Exiting...."
    exit 3
fi

echo ""
echo "--------------------------------------------------------"
echo ""

echo "I       Currently running Hub version $OLD_VER"
echo "I       New software is version $HUB_VERSION"
echo ""

read -p "!   Press y to Confirm and Make Update, n to Cancel: " -n 1 -r
echo ""
if [ ! $REPLY == "y" ];
then
    echo "X       Aborted, exiting..."
    rm -rf /mnt/sda1/.update-files
    exit 4
fi

# Else, make update
if [ ! -d /mnt/sda1/$HUB_VERSION ];
then
    mkdir /mnt/sda1/$HUB_VERSION
fi

cd /mnt/sda1/$HUB_VERSION

echo "I       Copying files..."
mv /mnt/sda1/.update-files/* /mnt/sda1/$HUB_VERSION

echo ""
echo "========================================================"
echo "--------------------------------------------------------"
echo ""
echo ""

# Perform the update:
./install.sh

echo ""
echo ""
echo "--------------------------------------------------------"
echo "========================================================"
echo ""

echo "I       Cleaning up..."
rm -rf /mnt/sda1/.update-files

echo "Done!"
