#!/bin/bash

echo "!   This will DELETE all of the .git directories in this folder tree"
echo "!   Which will potentially cause you significant irritation!"
echo "!"

read -p "!   Press Y to Confirm and Continue, anything else to Cancel: " -n 1 -r
echo ""
if [ ! $REPLY == "Y" ]
then
    echo "I   Aborted, exiting..."
    exit
fi

. ./VERSION

echo ""
echo "I   Deleting all .git files found...."

find ./ -name '.git*' -exec rm -rvf {} +

echo ""
FNAME="OpenWRT-HubPlusConfig-$HUB_VERSION"
echo "I   Making Zip at ../$FNAME.zip"

zip -r ../$FNAME.zip ./

echo ""
echo "I   Done, exiting."
echo "I   You'll find the Zip at ../$FNAME.zip"
