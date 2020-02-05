#add constraints
add_files -fileset constrs_1 -norecurse ./constraints/system.xdc

#add source
add_files ../source

#Add user ips
set_property ip_repo_paths ../ipcores/repo [current_project]
#import_ip will generated ip files in qwi02_cam2hdmi.srcs
#import_ip ../ipcores/vid_in_axi4s/vid_in_axi4s.xci
#add_files will generated ip files in source folder
add_files -fileset sources_1 -norecurse ../ipcores/vid_in_axi4s/vid_in_axi4s.xci
#copy usr files
update_compile_order -fileset sources_1
generate_target -force all [get_files vid_in_axi4s.xci]
eval file copy -force [glob ../ipcores/vid_in_axi4s/vid_in_axi4s.v] ../ipcores/vid_in_axi4s/synth/
eval file copy -force [glob ../ipcores/vid_in_axi4s/v_vid_in_axi4s_v4_0_formatter.v] ../ipcores/vid_in_axi4s/v_vid_in_axi4s_v4_0_1/hdl/verilog/
export_ip_user_files -of_objects [get_files ../ipcores/vid_in_axi4s/vid_in_axi4s.xci] -no_script -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ../ipcores/vid_in_axi4s/vid_in_axi4s.xci]
launch_run -jobs 2 vid_in_axi4s_synth_1

#build system
source ./system.tcl
generate_target -force all [get_files ./system/system/system.bd]
make_wrapper -files [get_files ./system/system/system.bd] -top
add_files -norecurse ./system/system/hdl/system_wrapper.v
