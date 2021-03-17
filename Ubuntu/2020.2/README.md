# Ubuntu 2020.2 for [TySOM-3A-ZU19EG](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3a) and [TySOM-3-ZU7EV](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3) boards

## Table of Content
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Instruction](#instruction)

<a name="introduction"/>

## Introduction

This instruction provides an instruction for building Ubuntu 2020.2 version with PetaLinux 2020.2 for TySOM boards:
- [TySOM-3A-ZU19EG](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3a)
- [TySOM-3-ZU7EV](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3)

This instruction is based on [ubuntu-on-zynq-and-zynqmp-devices](https://www.dspsandbox.org/ubuntu-on-zynq-and-zynqmp-devices/) page.

<a name="requirements"/>

## Requirements

1. Hardware requirements

  - [TySOM-3A-ZU19EG](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3a)
  - [TySOM-3-ZU7EV](https://www.aldec.com/en/products/emulation/tysom_boards/zynq_ultrascale_mpsoc_boards/tysom_3)

2. Software requirements

  - Petalinux 2020.2

    * [Petalinux BSP for TySOM-3A-ZU19EG](https://github.com/aldec/TySOM-3A-ZU19EG/tree/master/Petalinux_BSP/TySOM-3A-ZU19EG/2020.2)
    * [Petalinux BSP for TySOM-3-ZU7EV](https://github.com/aldec/TySOM-3-ZU7EV/tree/master/Petalinux_BSP/TySOM-3-ZU7EV/2020.2)

<a name="instruction"/>

## Instruction

1. Source a Petalinux configuration file
```
source <petalinux_installation_path>/petalinux-2020.2/settings.sh
```

2. Create a project with using the BSP.
```
petalinux-create -t project -s <path>/<BOARD_NAME>.bsp
```

Where *BOARD_NAME*:
- TySOM-3A-ZU19EG
- TySOM-3-ZU7EV

3. Go to the project directory
```
cd ./<BOARD_NAME>
```

Where *BOARD_NAME*:
- TySOM-3A-ZU19EG
- TySOM-3-ZU7EV

4. Configure PetaLinux project
```
petalinux-config
```
Use *Image Packaging Configuration -> Root filesystem-> SD card*.

Exit the configuration tool and save.

5. Build PetaLinux project
```
petalinux-build
```

6. Create the boot image
```
petalinux-package --boot --force --fpga --u-boot
```

7. Prepare SD card

Please follow the instructions on the website for prepare sd_card: [How to format SD card for SD boot](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842385/How+to+format+SD+card+for+SD+boot)

8. boot partition

Copy the following set of files to boot partition:
- BOOT.BIN (images/linux/BOOT.BIN)
- boot.scr (images/linux/boot.scr)
- image.ub (images/linux/image.ub)
- uEnv.txt (pre-built/linux/images/uEnv.txt)

9. Download the root filesystem. For Ubuntu 18.04 LTS run:
```
wget -c https://rcn-ee.com/rootfs/eewiki/minfs/ubuntu-18.04.3-minimal-armhf-2020-02-10.tar.xz
tar xf ubuntu-18.04.3-minimal-armhf-2020-02-10.tar.xz
```

10. Load the filesystem onto the root partition
```
cd <sd_card_path>/root/
sudo su
tar xfvp <path>/ubuntu-18.04.3-minimal-armhf-2020-02-10/armhf-rootfs-ubuntu-bionic.tar -C .
chmod 755 <sd_card_path>/root/
```

11. (optional) If you want to use HDMI, you have to extract *lib/modules/5.4.0-xilinx-v2020.2* from the Petalinux project and copy onto the root partition.

  a. Unpack images

```
cd <PetaLinux_project>/images/linux
dd bs=64 skip=1 if=rootfs.cpio.gz.u-boot of=ramdisk.cpio.gz
gunzip ramdisk.cpio.gz
mkdir ramdisk && cd ramdisk
sudo su
cpio -i -F ../ramdisk.cpio
```

  b. Copy onto root partition
```
cd <sd_card_path>/root/lib/
cp -rf <PetaLinux_project>/images/linux/ramdisk/lib/modules .
```

12. Final steps

Prepare your device for SD card boot (check jumper settings). Insert the SD card and power on your Zynq/ZynqMP.

Log into the Ubuntu OS (User: ubuntu Password: temppwd)
