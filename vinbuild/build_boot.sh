#! /bin/bash

TOOL_CHAIN=~/setup/PetaLinux_v2018.2/tools/linux-i386/gcc-arm-linux-gnueabi/bin
PATH=$PATH:~/tools/hsm/bin
CORE_NUM=4
ROOT_DIR=$PWD
PARENT_DIR="$(dirname "$ROOT_DIR")"
PETALINUX_IMAGE_DIR=/home/hoa/workspace/pz7015_fmc2_2018_2/images/linux

export PATH=$PATH:${TOOL_CHAIN}
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

DEVICE_TREE_SRC=$PARENT_DIR/devicetree-xlnx/user-dt/system.dtb
DEVICE_TREE_DTS=$PWD/arch/arm/dts/VSM_RU_5G_DeviceTree.dtb

if [ ! -d $PARENT_DIR/boot_image ]; then
	mkdir -p $PARENT_DIR/boot_image
fi

# Build u-boot
# rm -rf u-boot.elf
cp $DEVICE_TREE_SRC $DEVICE_TREE_DTS
make picozed_defconfig
make -j $CORE_NUM

cp u-boot $PARENT_DIR/boot_image/u-boot.elf

cd $PARENT_DIR/boot_image
mv -f BOOT.BIN BOOT_OLD.BIN

### Create zynq.bif file used by bootgen
echo 'the_ROM_image:' > zynq.bif
echo '{' >> zynq.bif
echo '	[bootloader] fsbl.elf' >> zynq.bif
echo '	system.bit' >> zynq.bif
echo '	u-boot.elf' >> zynq.bif
echo '}' >> zynq.bif

### Copy fsbl and system_top.bit into the output folder
cp $PETALINUX_IMAGE_DIR/zynq_fsbl.elf fsbl.elf
cp $PETALINUX_IMAGE_DIR/system.bit system.bit

### Build BOOT.BIN
(
	bootgen -arch zynq -image zynq.bif -o BOOT.BIN -w
)

if [ "$?" -eq 0 ]; then
	echo "Suscessfully creat BOOT.BIN in $PARENT_DIR/boot_image"
fi
cd $ROOT_DIR 
