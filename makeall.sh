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

PrjName=$1
cd $MakeFwFileDir
./makefw.sh $1
