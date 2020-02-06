#******************************************************************************
# runsw.tcl
#
# This module is the tcl script of building software.
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       Feb. 5, 2020      Initial Release
#******************************************************************************

set buildName qwi02_cam2hdmi
set hwName qwi02_cam2hdmi
set proc ps7_cortexa9_0
set os standalone
set srcCode ../software

sdk set_workspace ./workspace
sdk create_hw_project -name hw_$buildName -hwspec ./$hwName.hdf
sdk create_bsp_project -name bsp_$buildName -hwproject hw_$buildName -proc $proc -os $os
# creat app project and fsbl project
sdk create_app_project -name $buildName -hwproject hw_$buildName -proc $proc -os $os -lang C -bsp bsp_$buildName -app {Empty Application}
sdk create_app_project -name $buildName\_fsbl -hwproject hw_$buildName -proc $proc -os $os -lang C -app {Zynq FSBL}

# build project
eval file copy [glob $srcCode/*] ./workspace/$buildName/src/
sdk build_project -type bsp -name bsp_$buildName
sdk build_project -type app -name $buildName
sdk build_project -type bsp -name $buildName\_fsbl_bsp
sdk build_project -type app -name $buildName\_fsbl

# create image
exec bootgen -arch zynq -image image.bif -w -o BOOT.bin
exit
