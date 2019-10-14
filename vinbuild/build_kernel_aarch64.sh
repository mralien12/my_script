# !/bin/bash

if [ $# -lt 1 ]; then
        echo "Usage: $0 your_board_defconfig"
        echo "Usage: $0 your_board_defconfig --update" //Update image.ub
	echo "	Ex: $0 xilinx_zynq_defconfig"
	echo "	Ex: $0 picozed_defconfig"
	echo "	Ex: $0 zcu102_defconfig"
        exit
fi

export ARCH=arm64
CORE_NUM=4
TOOL_CHAIN=""
COMPILER=""
IMAGE=""

if [ $ARCH == "arm" ]; then
	TOOL_CHAIN=~/setup/PetaLinux_v2018.2/tools/linux-i386/gcc-arm-linux-gnueabi/bin
	COMPILER=arm-linux-gnueabihf-
	IMAGE=zImage
elif [ $ARCH == "arm64" ]; then
	TOOL_CHAIN=~/setup/PetaLinux_v2018.2/tools/linux-i386/aarch64-linux-gnu/bin
	COMPILER=aarch64-linux-gnu-
	IMAGE=Image
fi

export PATH=$PATH:${TOOL_CHAIN}
export CROSS_COMPILE=${COMPILER}

make $1
make -j ${CORE_NUM}

retVal=$?
if [ $retVal -ne 0 ];then
	echo "Failed to build kernel!!"
	exit
fi

cp ./arch/${ARCH}/boot/${IMAGE} ../user-image
ret=$?
if [ $ret -ne 0 ];then
	echo "Error to cpy arch/${ARCH}/boot/${IMAGE} to ../user-image"
	exit $ret
fi

echo "Copy arch/${ARCH}/boot/${IMAGE} to ../user-image sucesfully"

if [ "$2" == "--update" ]; then
	cd ../user-image
	./create_user_image.sh
	cd $ROOT_DIR
fi
