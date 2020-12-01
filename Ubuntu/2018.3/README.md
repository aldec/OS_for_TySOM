# OS_for_TySOM
Operating Systems for Aldec TySOM boards

# Table of Content
1. [How to build](#how_to_build)

<a name="how_to_build"/>

## How to build

This instruction is based on [Xilinx instructon](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841937/Zynq+UltraScale+MPSoC+Ubuntu+part+2+-+Building+and+Running+the+Ubuntu+Desktop+From+Sources).

1. Ubuntu:
  - Download Xilinx files for Ubuntu from [link](https://www.xilinx.com/member/forms/download/xef.html?filename=Ubuntu_Desktop_Release_2018_3_1.zip).

  - Unzip the downloaded package.

  - Create SD card

```
cd Ubuntu_Desktop_Release_2018_3/Ready_to_test_images
su
dd if=ZCU102_UbuntuDesktop_2018_3.img of=/dev/sdd status=progress
```
Note: Use a proper path to SD card.

2. PetaLinux

  - Download BSP file
    - [TySOM-3-ZU7EV.bsp](https://github.com/aldec/TySOM-3-ZU7EV/blob/master/Petalinux_BSP/TySOM-3-ZU7EV/2018.3/TySOM-3-ZU7EV.bsp)
    - [TySOM-3A-ZU19EG](https://github.com/aldec/TySOM-3A-ZU19EG/blob/master/Petalinux_BSP/TySOM-3A-ZU19EG/2018.3/TySOM-3A-ZU19EG.bsp)

  - source \<Path to PetaLinux\>/2018.3/settings.sh \<Path to PetaLinux\>/2018.3

  - Create a new project in PetaLinux

```  
petalinux-create -t project -s TySOM-3-ZU7EV.bsp
```
or
```  
petalinux-create -t project -s TySOM-3A-ZU19EG.bsp
```

  - Build the new project

```
cd TySOM-3-ZU7EV
petalinux-build
```
or
```
cd TySOM-3A-ZU19EG
petalinux-build
```

  - Create BOOT.bin

```
petalinux-package --boot --force --fsbl --pmufw --fpga --atf --u-boot
```

6. Get kernel modules from rootfs.cpio (files are in src/modules directory)

```
cd images/linux
mkdir rootfs
cd rootfs
change user to root
cpio -idv < ../rootfs.cpio
```
Copy module file to SD card, to partition with rootfs files
```
cp -rf lib/modules/4.14.0-xilinx-v2018.3/ /path/to/SD/rootfsPartition/lib/modules
```

  - Copy files Image, BOOT.bin, system.dtb to boot partition on SD card

  - Copy uEnv.txt (file is in src directory) to boot partition on SD card

  - Copy script aldec-utils.sh (file is in src directory) to /root directory on rootfs partition on SD card

  - Copy rc.local (file is in src directory) to /etc directory on rootfs partition on SD card

  - Insert SD card to TySOM and turn on board
