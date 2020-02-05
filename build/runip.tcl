#******************************************************************************
# runip.tcl
#
# This module is the tcl script of building ip cores.
#
# Change History:
#  VER.   Author         DATE              Change Description
#  1.0    Qiwei Wu       Feb. 5, 2020      Initial Release
#******************************************************************************

proc RunIp {IpName coreNum ModifyIpCode BeModifyIpCode args} {
   # Remove IP existing target
   reset_target all [get_files $IpName.xci]
   export_ip_user_files -of_objects  [get_files  $IpName.xci] -sync -no_script -force -quiet
   delete_ip_run [get_ips $IpName]

   # Generate IP target
   # config_ip_cache -clear_output_repo
   generate_target all [get_files  $IpName.xci]
   # Replace needed IP code
   eval file copy -force [glob $ModifyIpCode/*.v] $BeModifyIpCode
   foreach i $args {
      eval file copy -force [glob $ModifyIpCode/$args/*.v] $args
   }
   # Create and OOC run for the IP
   export_ip_user_files -of_objects [get_files $IpName.xci] -no_script -sync -force -quiet
   create_ip_run [get_files -of_objects [get_fileset sources_1] $IpName.xci] -force -quiet
   # config_ip_cache -clear_output_repo
   launch_runs -jobs $coreNum $IpName\_synth_1
}

# Example
# RunIp vid_in_axi4s 2 ../ipcores/vid_in_axi4s/usr/synth ../ipcores/vid_in_axi4s/synth /v_vid_in_axi4s_v4_0_1/hdl/verilog/
