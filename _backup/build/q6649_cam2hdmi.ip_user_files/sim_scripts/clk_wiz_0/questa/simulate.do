onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "E:/8_software/xilinx/Vivado/2015.4/lib/win64.o/libxil_vsim.dll" -lib xil_defaultlib clk_wiz_0_opt

do {wave.do}

view wave
view structure
view signals

do {clk_wiz_0.udo}

run -all

quit -force
