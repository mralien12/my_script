# !/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: $0 your_board_defconfig"
	echo "Ex: $0 xilinx_zynq_defconfig"
        exit
fi

# TOOL_CHAIN=~/xilinx/2018.2/tools/linux-i386/gcc-arm-linux-gnueabi/bin
TOOL_CHAIN=~/setup/PetaLinux_v2018.2/tools/linux-i386/gcc-arm-linux-gnueabi/bin
CORE_NUM=4

export PATH=$PATH:${TOOL_CHAIN}
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

#source ~/xilinx/2018.2/settings.sh
make $1
make -j ${CORE_NUM}

cp ./arch/${ARCH}/boot/zImage ../user-image
ret=$?
if [ $ret -ne 0 ];then
	echo "Error to cpy arch/${ARCH}/boot/zImage to ../user-image"
	exit $ret
fi
echo "Copy arch/${ARCH}/boot/zImage to ../user-image sucesfully"