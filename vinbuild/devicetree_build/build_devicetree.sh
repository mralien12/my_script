#!/bin/bash

VERSION=1.0.1
# PATH=$PATH:/home/quyencv/xilinx/2018.2/tools/hsm/bin

# Provide path to xsdk tool
PATH=$PATH:/home/hoa/setup/PetaLinux_v2018.2/tools/hsm/bin
# Provide path to dtc tool
PATH=$PATH:/home/hoa/setup/PetaLinux_v2018.2/tools/linux-i386/petalinux/bin

ROOT_DIR=$PWD
PARENT_DIR="$(dirname "$ROOT_DIR")"
KERNEL_INC=${PARENT_DIR}/linux-xlnx/include

SRC_DIR=$ROOT_DIR/device-tree
USER_DT_DIR=$ROOT_DIR/user-dt

# CPU_PROC=ps7_cortexa9_0	# Zynq
CPU_PROC=psu_cortexa53_0	# Zynqmp

BuildDeviceTree() {
        gcc  -E -nostdinc -Ulinux -I$KERNEL_INC -I$SRC_DIR -I$USER_DT_DIR \
		-x assembler-with-cpp -o ${USER_DT_DIR}/system-top.pp ${USER_DT_DIR}/system-user.dts
	ret=$?
	if [ $ret -ne 0 ];then
		echo "BuildDeviceTree: Failed to compile by gcc"
		return $ret
	fi

	dtc -I dts -O dtb -R 8 -p 0x1000 -i $SRC_DIR -i $SRC_DIR/include -o ${USER_DT_DIR}/system.dtb ${USER_DT_DIR}/system-top.pp
	ret=$?
	if [ $ret -ne 0 ];then
		echo "BuildDeviceTree: Failed to build device tree!!!"
		return $ret
	fi

	dtc -I dtb -O dts -o $USER_DT_DIR/system.dts $USER_DT_DIR/system.dtb

	rm -f ${USER_DT_DIR}/*.pp
}

usage() {
	echo "1. Copy your <HDF Filename>.hdf to hdf/hardware_description.hdf"
	echo "2. Run bellow command to build."
	echo "	$0 --help			// To get help."
	echo "	$0 --hdf <path_to_hdf_file>	// To recreate device tree from hdf."
	echo "	$0 				// To rebuild Device Tree."
	echo "	$0 --update 			// To rebuild Device Tree and update image.ub."
	exit 0;
}

if [ "$1" == "--help" ]; then
	usage
fi

echo "Generating Device tree..."
if [ "$1" == "--hdf" ]; then
	
	# Copy your hdf file.
	if [ $2 != "" -a -f $2 ]; then
		if [ -d hdf ]; then
			if [ -f hdf/hardware_description.hdf ]; then
				mv hdf/hardware_description.hdf hdf/hardware_description.hdf_bak
			fi
		else
			mkdir hdf
		fi
		cp $2 hdf/hardware_description.hdf
	else
		usage
	fi

	if [ -d ${SRC_DIR} ]; then
		rm -rf device-tree-old
		mv device-tree device-tree-old
	fi

	mkdir device-tree
	xsdk -batch -source tcl/run_hsi_cmds.tcl $CPU_PROC
fi
ret=$?
if [ $ret -ne 0 ]; then
	echo "Generated Device Tree failed!!!"
        exit $ret
else
	echo "Generated Device Tree sucessfully!!!"
fi

echo "Building Device tree..."
BuildDeviceTree
ret=$?
if [ $ret -ne 0 ]; then
        exit $ret
fi
echo "${USER_DT_DIR}/system.dtb is created"

cp ${USER_DT_DIR}/system.dtb ../user-image
echo "Copy system.dtb to ${PARENT_DIR}/user-image sucesfully!!!"


if [ "$1" == "--update" -o "$3" == "--update" ]; then
	cd ../user-image
	./create_user_image.sh
	cd $ROOT_DIR
fi
