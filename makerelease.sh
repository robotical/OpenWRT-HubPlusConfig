#!/bin/bash


#echo ""
#echo "I   Deleting all .git files found...."
#find ./ -name '.git*' -exec rm -rvf {} +

if [ ! -d ./src ];
then
    echo "!   Can't see /src, don't have anywhere to build release from!"
    echo "!   Exiting..."
    exit 1
fi

# Check Submodules have been absorbed:
if [ -d ./src/scratch3-gui/.git ];
then
    echo "!   Submodule 'scratch3-gui' .git is a directory not a file, see README.md"
    exit 1
fi

if [ -d ./src/scratchx/.git ];
then
    echo "!   Submodule 'scratchx' .git is a directory not a file, see README.md"
    exit 1
fi
    

echo ""
echo "I   Enter new release version"

read -p ">   Type the version then press <enter>: "
HUB_VERSION=$REPLY
echo ""
echo "Your version is:"
echo ""
echo "    '$HUB_VERSION'"
echo ""

read -p ">   Press Y to Confirm, Ctrl-c to cancel: " -n 1 -r
echo ""
if [ ! $REPLY == "Y" ]
then
    echo "Aborted, exiting..."
    exit 2
fi

if [ ! -d ./release ];
then
    mkdir ./release
else
    echo "!   ./release dir exists, please delete it"
    exit 3
fi

echo "I   Will Copy over files from ./src to ./release/$HUB_VERSION/"

mkdir ./release/$HUB_VERSION
cp -r ./src/* ./release/$HUB_VERSION
cp ./.signing.pubkey ./release/.signing.pubkey

# Overwrite VERSION file with this new version number
touch ./release/$HUB_VERSION/VERSION
echo '#!/usr/bin/env sh' > ./release/$HUB_VERSION/VERSION
echo "export HUB_VERSION='$HUB_VERSION'" >> ./release/$HUB_VERSION/VERSION

echo ""
FNAME="OpenWRT-HubPlusConfig-$HUB_VERSION"

if [ -f  $FNAME ];
then
    echo "!   Zip already exists, deleting!"
    rm "$FNAME.zip"
fi

echo "I   Making Zip at ./$FNAME.zip"

cd ./release
zip -r ../$FNAME.zip ./$HUB_VERSION
zip ../$FNAME.zip ./.signing.pubkey
cd ..

rm -rf ./release

echo ""
echo "I   You'll find the Zip at ./$FNAME.zip"
echo ""
echo "I   DON'T FORGET to 'git tag' a new release"
echo ""
echo "I   Done, exiting."

