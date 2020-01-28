#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=E:/8_software/xilinx/SDK/2015.4/bin;E:/8_software/xilinx/Vivado/2015.4/ids_lite/ISE/bin/nt64;E:/8_software/xilinx/Vivado/2015.4/ids_lite/ISE/lib/nt64:E:/8_software/xilinx/Vivado/2015.4/bin
else
  PATH=E:/8_software/xilinx/SDK/2015.4/bin;E:/8_software/xilinx/Vivado/2015.4/ids_lite/ISE/bin/nt64;E:/8_software/xilinx/Vivado/2015.4/ids_lite/ISE/lib/nt64:E:/8_software/xilinx/Vivado/2015.4/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log q6649_cam2hdmi.vds -m64 -mode batch -messageDb vivado.pb -notrace -source q6649_cam2hdmi.tcl
