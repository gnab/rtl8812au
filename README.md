## Realtek 802.11ac (rtl8812au)

This is a fork of the Realtek 802.11ac (rtl8812au) v4.2.2 (7502.20130507)
driver altered to build on Linux kernel version >= 3.10.

### Purpose

My D-Link DWA-171 wireless dual-band USB adapter needs the Realtek 8812au
driver to work under Linux.

The current rtl8812au version (per nov. 20th 2013) doesn't compile on Linux
kernels >= 3.10 due to a change in the proc entry API, specifically the
deprecation of the `create_proc_entry()` and `create_proc_read_entry()`
functions in favor of the new `proc_create()` function.

### Building

The Makefile is preconfigured to handle most x86/PC versions.  If you are compiling for something other than an intel x86 architecture, you need to first select the platform, e.g. for the Raspberry Pi, you need to set the I386 to n and the ARM_RPI to y:
```sh
...
CONFIG_PLATFORM_I386_PC = n
...
CONFIG_PLATFORM_ARM_RPI = y
```


```sh
# apt install build-essential bc git wget
# cd /usr/src
# git clone --depth 1 https://github.com/raspberrypi/linux.git
# ln -s linux $(uname -r)
# ln -s /usr/src/linux /lib/modules/$(uname -r)/build
```


```sh
# cd linux
# wget -O Module.symvers https://raw.githubusercontent.com/raspberrypi/firmware/master/extra/Module7.symvers
# KERNEL=kernel7
# make bcm2709_defconfig
# make prepare
# make modules_prepare
```

### Download Kernel soucers
```
# sudo wget "https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source" -O /usr/bin/rpi-source
# sudo chmod 755 /usr/bin/rpi-source
# rpi-source --skip-gcc

```

After loading the module, a wireless network interface named __Realtek 802.11n WLAN Adapter__ should be available.

```
# # download the rtl8812au kernel driver and compile it, takes some minutes
# git clone "https://github.com/gnab/rtl8812au"
# cd rtl8812au
# make
```

```
# # copy the driver and use it
# sudo cp 8812au.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless
# sudo depmod -a
# sudo modprobe 8812au

```

```
# check wlan0 interface appeared
# ifconfig
# iwconfig
```
