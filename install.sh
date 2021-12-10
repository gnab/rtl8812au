#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

make -j$(nproc) &&
cp 8812au.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless &&
depmod &&
echo "
                       ***Success***
***Module will be activated automatically at next reboot***
" &&

while true; do
    read -p "Do you wish to activate the module now? (y/n)" yn
    case $yn in
        [Yy]* ) insmod 8812au.ko && echo "***Module activated***" && break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
