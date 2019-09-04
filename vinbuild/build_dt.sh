#!/bin/bash

# PATH=$PATH:/home/quyencv/xilinx/2018.2/tools/hsm/bin
PATH=$PATH:~/tools/hsm/bin
PATH=$PATH:~/tools/dtc
ROOT_DIR=$PWD
SRC_DIR=$ROOT_DIR/device-tree
KERNEL_INC=${ROOT_DIR}/../linux-xlnx/include
USER_DT_FILE=$ROOT_DIR/user-dt/system-user.dtsi

BuildDeviceTree() {
	cp ${USER_DT_FILE} ${SRC_DIR}
        gcc  -E -nostdinc -Ulinux -I$SRC_DIR -I$KERNEL_INC -x assembler-with-cpp -o ${SRC_DIR}/system-top.pp ${SRC_DIR}/system-top.dts
        dtc -I dts -O dtb -R 8 -p 0x1000 -i $SRC_DIR -i $SRC_DIR/include -o ${SRC_DIR}/system.dtb ${SRC_DIR}/system-top.pp
#        dtc -I dtb -O dts -o $SRC_DIR/plnx_aarch64-system.dts $SRC_DIR/plnx_aarch64-system.dtb

	rm -f ${SRC_DIR}/system-user.dtsi ${SRC_DIR}/*.pp
}

if [ "$1" == "--help" ]; then
	echo "1. Copy your <HDF Filename>.hdf to hdf/hardware_description.hdf"
	echo "2. Run bellow command to build."
	echo "	$0 --help			// To get help."
	echo "	$0 --hdf <path_to_hdf_file>	// To recreate device tree from hdf."
	echo "	$0 				// To rebuild Device Tree."
	exit 0;
fi

echo "Generating Device tree..."
if [ "$1" == "--hdf" ]; then
	
	# Copy your hdf file.
	if [ -f $2 ]; then
		if [ -f hdf/hardware_description.hdf ]; then
			mv hdf/hardware_description.hdf hdf/hardware_description.hdf_bak
		fi
		cp $2 hdf/hardware_description.hdf
	fi

	if [ -d ${SRC_DIR} ]; then
		rm -rf device-tree-old
		mv device-tree device-tree-old
	fi

	mkdir device-tree
	xsdk -batch -source tcl/run_hsi_cmds.tcl

	echo '#include "system-user.dtsi"' >> ${SRC_DIR}/system-top.dts
fi

echo "Building Device tree..."
BuildDeviceTree
echo "DTS/DTSI/DTB is in device-tree"

cp ${SRC_DIR}/system.dtb ../user-image
echo "Copy ${SRC_DIR}/system.dtb to ../user-image sucesfully"

