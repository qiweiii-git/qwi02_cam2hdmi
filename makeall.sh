#*****************************************************************************
# makeall.sh
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       May. 4, 2019      Initial Release
#*****************************************************************************
#!/bin/bash
source /opt/Xilinx/Vivado/2015.4/settings64.sh

MakeFwFileDir='build'

cd $MakeFwFileDir
./makefw.sh qwi02_cam2hdmi xc7z020clg400-2 2
cd $MakeFwFileDir
./makesw.sh qwi02_cam2hdmi qwi02_cam2hdmi
