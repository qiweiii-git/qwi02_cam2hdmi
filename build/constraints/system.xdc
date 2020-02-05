#system.xdc

#clock
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk_50m]
set_property PACKAGE_PIN U18 [get_ports sys_clk_50m]
create_clock -period 20.000 -waveform {0.000 10.000} [get_ports sys_clk_50m]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets u_clk_25m/inst/clk_in1_clk_wiz_0]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cam_pclk_IBUF]

#HDMI interface
set_property IOSTANDARD TMDS_33  [get_ports  TMDS_clk_n        ]
set_property IOSTANDARD TMDS_33  [get_ports  TMDS_clk_p        ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_n[0]}   ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_p[0]}   ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_n[1]}   ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_p[1]}   ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_n[2]}   ]
set_property IOSTANDARD TMDS_33  [get_ports {TMDS_data_p[2]}   ]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_OEN[0]}      ]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_hpd_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports  hdmi_ddc_scl      ]
set_property IOSTANDARD LVCMOS33 [get_ports  hdmi_ddc_sda      ]

set_property PACKAGE_PIN N18 [get_ports  TMDS_clk_p        ]
set_property PACKAGE_PIN V20 [get_ports {TMDS_data_p[0]}   ]
set_property PACKAGE_PIN T20 [get_ports {TMDS_data_p[1]}   ]
set_property PACKAGE_PIN N20 [get_ports {TMDS_data_p[2]}   ]
set_property PACKAGE_PIN V16 [get_ports {HDMI_OEN[0]}      ]
set_property PACKAGE_PIN Y19 [get_ports {hdmi_hpd_tri_i[0]}]
set_property PACKAGE_PIN R18 [get_ports  hdmi_ddc_scl      ]
set_property PACKAGE_PIN R16 [get_ports  hdmi_ddc_sda      ]

#camera interface
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cam_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_scl     ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_sda     ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_pwdn    ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_xclk    ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_pclk    ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_href    ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_vsync   ]
set_property IOSTANDARD LVCMOS33 [get_ports  cam_rst_n   ]

set_property PACKAGE_PIN L19 [get_ports {cam_data[9]}]
set_property PACKAGE_PIN L20 [get_ports {cam_data[8]}]
set_property PACKAGE_PIN F19 [get_ports {cam_data[7]}]
set_property PACKAGE_PIN G20 [get_ports {cam_data[6]}]
set_property PACKAGE_PIN M19 [get_ports {cam_data[5]}]
set_property PACKAGE_PIN M20 [get_ports {cam_data[4]}]
set_property PACKAGE_PIN F20 [get_ports {cam_data[3]}]
set_property PACKAGE_PIN G19 [get_ports {cam_data[2]}]
set_property PACKAGE_PIN J19 [get_ports {cam_sda}    ]
set_property PACKAGE_PIN K19 [get_ports {cam_scl}    ]
set_property PACKAGE_PIN F17 [get_ports {cam_pwdn}   ]
set_property PACKAGE_PIN J18 [get_ports {cam_xclk}   ]
set_property PACKAGE_PIN K17 [get_ports {cam_pclk}   ]
set_property PACKAGE_PIN H18 [get_ports {cam_href}   ]
set_property PACKAGE_PIN K18 [get_ports {cam_vsync}  ]
set_property PACKAGE_PIN F16 [get_ports {cam_rst_n}  ]

#led indicator
set_property IOSTANDARD LVCMOS33 [get_ports led_indc]
set_property PACKAGE_PIN M15 [get_ports led_indc]

#eeprom
set_property IOSTANDARD LVCMOS33 [get_ports eeprom_scl]
set_property PACKAGE_PIN T19 [get_ports eeprom_scl]

set_property IOSTANDARD LVCMOS33 [get_ports eeprom_sda]
set_property PACKAGE_PIN W16 [get_ports eeprom_sda]

