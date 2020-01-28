proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.cache/wt [current_project]
  set_property parent.project_path Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.xpr [current_project]
  set_property ip_repo_paths {
  z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.cache/ip
  c:/Users/Administrator/AppData/Roaming/Xilinx/repo
  Z:/1_UnivPaper/1_Prj/13_q0508/repo
} [current_project]
  set_property ip_output_repo z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.cache/ip [current_project]
  add_files -quiet Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.runs/synth_1/q6649_cam2hdmi.dcp
  add_files -quiet Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp
  set_property netlist_only true [get_files Z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp]
  read_xdc -ref system_processing_system7_0_0 -cells inst z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_processing_system7_0_0/system_processing_system7_0_0.xdc]
  read_xdc -ref system_axi_vdma_0_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_0_0/system_axi_vdma_0_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_0_0/system_axi_vdma_0_0.xdc]
  read_xdc -prop_thru_buffers -ref system_axi_gpio_0_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0_board.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0_board.xdc]
  read_xdc -ref system_axi_gpio_0_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_gpio_0_0/system_axi_gpio_0_0.xdc]
  read_xdc -prop_thru_buffers -ref system_rst_processing_system7_0_140M_0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_140M_0/system_rst_processing_system7_0_140M_0_board.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_140M_0/system_rst_processing_system7_0_140M_0_board.xdc]
  read_xdc -ref system_rst_processing_system7_0_140M_0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_140M_0/system_rst_processing_system7_0_140M_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_140M_0/system_rst_processing_system7_0_140M_0.xdc]
  read_xdc -prop_thru_buffers -ref system_rst_processing_system7_0_100M_0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_100M_0/system_rst_processing_system7_0_100M_0_board.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_100M_0/system_rst_processing_system7_0_100M_0_board.xdc]
  read_xdc -ref system_rst_processing_system7_0_100M_0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_100M_0/system_rst_processing_system7_0_100M_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_rst_processing_system7_0_100M_0/system_rst_processing_system7_0_100M_0.xdc]
  read_xdc -ref system_axi_vdma_1_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_1_0/system_axi_vdma_1_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_1_0/system_axi_vdma_1_0.xdc]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files z:/1_UnivPaper/1_Prj/13_q0508/build/q6649_cam2hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
  read_xdc Z:/1_UnivPaper/1_Prj/13_q0508/source/system.xdc
  read_xdc -ref system_axi_vdma_0_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_0_0/system_axi_vdma_0_0_clocks.xdc
  set_property processing_order LATE [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_0_0/system_axi_vdma_0_0_clocks.xdc]
  read_xdc -ref system_v_tc_0_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_v_tc_0_0/system_v_tc_0_0_clocks.xdc
  set_property processing_order LATE [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_v_tc_0_0/system_v_tc_0_0_clocks.xdc]
  read_xdc -ref system_v_axi4s_vid_out_0_0 -cells inst z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_v_axi4s_vid_out_0_0/system_v_axi4s_vid_out_0_0_clocks.xdc
  set_property processing_order LATE [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_v_axi4s_vid_out_0_0/system_v_axi4s_vid_out_0_0_clocks.xdc]
  read_xdc -ref system_axi_vdma_1_0 -cells U0 z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_1_0/system_axi_vdma_1_0_clocks.xdc
  set_property processing_order LATE [get_files z:/1_UnivPaper/1_Prj/13_q0508/system/ip/system_axi_vdma_1_0/system_axi_vdma_1_0_clocks.xdc]
  link_design -top q6649_cam2hdmi -part xc7z020clg400-2
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force q6649_cam2hdmi_opt.dcp
  report_drc -file q6649_cam2hdmi_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file q6649_cam2hdmi.hwdef}
  place_design 
  write_checkpoint -force q6649_cam2hdmi_placed.dcp
  report_io -file q6649_cam2hdmi_io_placed.rpt
  report_utilization -file q6649_cam2hdmi_utilization_placed.rpt -pb q6649_cam2hdmi_utilization_placed.pb
  report_control_sets -verbose -file q6649_cam2hdmi_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force q6649_cam2hdmi_routed.dcp
  report_drc -file q6649_cam2hdmi_drc_routed.rpt -pb q6649_cam2hdmi_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file q6649_cam2hdmi_timing_summary_routed.rpt -rpx q6649_cam2hdmi_timing_summary_routed.rpx
  report_power -file q6649_cam2hdmi_power_routed.rpt -pb q6649_cam2hdmi_power_summary_routed.pb
  report_route_status -file q6649_cam2hdmi_route_status.rpt -pb q6649_cam2hdmi_route_status.pb
  report_clock_utilization -file q6649_cam2hdmi_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force q6649_cam2hdmi.mmi }
  write_bitstream -force q6649_cam2hdmi.bit 
  catch { write_sysdef -hwdef q6649_cam2hdmi.hwdef -bitfile q6649_cam2hdmi.bit -meminfo q6649_cam2hdmi.mmi -file q6649_cam2hdmi.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

