#!/bin/sh

# mkimage tool will be created during u-boot build process. Need to export path to mkimage tool.
# mkimage_path=/home/quyencv/workspace/pz7015_fmc2_2018_2/build/tmp/sysroots-components/x86_64/u-boot-mkimage-native/usr/bin
PATH=$PATH:~/tools/dtc

mkimage_path=~/workspace/pz7015_fmc2_2018_2/build/tmp/work/plnx_zynq7-xilinx-linux-gnueabi/u-boot-xlnx/v2018.01-xilinx-v2018.2+git999-r0/u-boot-xlnx-v2018.01-xilinx-v2018.2+git999/tools

if [ -f image.ub ]; then
	mv image.ub image_old.ub
fi
${mkimage_path}/mkimage -f fitImage.its image.ub 

retVal=$?
if [ $retVal -ne 0 ];then
	echo "Create image.ub failed"
	exit
fi

echo "---------------------------------"
echo "Create image.ub succesfully!!!"



