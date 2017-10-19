#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt install build-essential bc git wget

cd /usr/src

git clone --depth 1 https://github.com/raspberrypi/linux.git

ln -s linux $(uname -r)
ln -s /usr/src/linux /lib/modules/$(uname -r)/build
cd linux

wget -O Module.symvers https://raw.githubusercontent.com/raspberrypi/firmware/master/extra/Module7.symvers
KERNEL=kernel7

make bcm2709_defconfig
make prepare
make modules_prepare

make &&
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
