#!/bin/bash
function vefificaRoot(){
    if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
    fi
}

function installDep(){
    for dep in  build-essential bc git wget; do
        sudo apt install $dep
    done
}

function configure(){

    cd /usr/src
    git clone --depth 1 https://github.com/raspberrypi/linux.git

    ln -s linux $(uname -r)
    ln -s /usr/src/linux /lib/modules/$(uname -r)/build
    cd linux

    wget -O Module.symvers https://raw.githubusercontent.com/raspberrypi/firmware/master/extra/Module7.symvers
    KERNEL=kernel7

    #make bcm2709_defconfig && make prepare && make modules_prepare

    for mak in bcm2709 prepare modules_prepare; do
        make $mak
    
    sudo wget "https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source" -O /usr/bin/rpi-source
    sudo chmod 755 /usr/bin/rpi-source
    rpi-source --skip-gcc

    git clone "https://github.com/gnab/rtl8812au"
    cd rtl8812au

    sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
    sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/g' Makefile

    make

    sudo cp 8812au.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless
    sudo depmod -a && sudo modprobe 8812au

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
}

verificaRoot
installDep
configure
