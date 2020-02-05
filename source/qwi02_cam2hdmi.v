//*****************************************************************************
// qwi02_cam2hdmi.v
// 
// Qiwei.Wu
// April 30, 2018
//
// This module is the wrapper of the ov5640 project.
// Revision 
// 0.01 - File Created
// 0.2  - using vid_in_axi4s modules in the wrapper module rather than block design 
// 0.3  - Add LED used for indecated FPGA configure success or not
// 0.5  - using rgb2dvi modules in the wrapper module rather than block design 
// 1.0  - Release at May 3, 2018
// 1.1  - IIC configured manually rather than controlled by software
// 1.2  - Add USB, ETH, SD, QSPI and HDMI DDC control in the block design
//*****************************************************************************

module qwi02_cam2hdmi
(
   //DDR interface
   inout     [14:0]   DDR_addr         ,
	inout     [2:0]    DDR_ba           ,
	inout              DDR_cas_n        ,
	inout              DDR_ck_n         ,
	inout              DDR_ck_p         ,
	inout              DDR_cke          ,
	inout              DDR_cs_n         ,
	inout     [3:0]    DDR_dm           ,
	inout     [31:0]   DDR_dq           ,
	inout     [3:0]    DDR_dqs_n        ,
	inout     [3:0]    DDR_dqs_p        ,
	inout              DDR_odt          ,
	inout              DDR_ras_n        ,
	inout              DDR_reset_n      ,
	inout              DDR_we_n         ,
   //fixed_io interface
	inout              FIXED_IO_ddr_vrn ,
	inout              FIXED_IO_ddr_vrp ,
	inout     [53:0]   FIXED_IO_mio     ,
	inout              FIXED_IO_ps_clk  ,
	inout              FIXED_IO_ps_porb ,
	inout              FIXED_IO_ps_srstb,
   //HDMI interface
   input     [0:0]    hdmi_hpd_tri_i   ,
   inout              hdmi_ddc_scl     ,
   inout              hdmi_ddc_sda     ,
	output    [0:0]    HDMI_OEN         ,
	output             TMDS_clk_n       ,
	output             TMDS_clk_p       ,
   output    [2:0]    TMDS_data_n      ,
	output    [2:0]    TMDS_data_p      ,
	//eeprom interface
	inout              eeprom_scl       ,
	inout              eeprom_sda       ,
   //camera interface
   input              sys_clk_50m      ,
	input              cam_vsync        ,//camera vsync
	input              cam_href         ,//camera hsync refrence
	input              cam_pclk         ,//camera pxiel clock
	input     [9:2]    cam_data         ,//camera data
   inout              cam_scl          ,//camera i2c clock
	inout              cam_sda          ,//camera i2c data
	output             cam_rst_n        ,//camera reset
   output             cam_xclk         ,
	output             cam_pwdn         ,
   //LED indicator
   output             led_indc
);

//*****************************************************************************
// Signals
//*****************************************************************************
wire   [31:0]    m_axis_video_tdata ;
wire             m_axis_video_tvalid;
wire             m_axis_video_tready;
wire             m_axis_video_tuser ;
wire             m_axis_video_tlast ;  

wire             clk_140m           ;
wire             clk_24m            ;
wire   [15:0]    cam_data_16b       ;
wire             cam_hblank_16b     ;
wire             cam_href_16b       ;
wire   [31:0]    vid_in_data        ;
reg    [7:0]     cam_data_ff0       ;
reg              cam_href_ff0       ;
reg              cam_vsync_ff0      ;

wire             pix_clk            ;
wire             pix_clk_5x         ;
wire             dynclk_lock_o      ;
wire   [23:0]    video_data         ;
wire             active_video       ;
wire             video_hsync        ;
wire             video_vsync        ;
wire             initial_en         ;
wire             clk_24m_fb         ;
 
//*****************************************************************************
// Processes
//*****************************************************************************

//*****************************************************************************
// Maps
//*****************************************************************************
MMCME2_BASE
#(
   .BANDWIDTH              ( "OPTIMIZED"        ),
   .CLKFBOUT_MULT_F        ( 19.5               ),
   .CLKFBOUT_PHASE         ( 0.0                ),
   .CLKIN1_PERIOD          ( 20.0               ),
   // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
   .CLKOUT0_DIVIDE_F       ( 40.625             ),
   // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
   .CLKOUT0_DUTY_CYCLE     ( 0.5                ),
   // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
   .CLKOUT0_PHASE          ( 0.0                ),
   .CLKOUT4_CASCADE        ( "FALSE"            ),
   .DIVCLK_DIVIDE          ( 1                  ),
   .REF_JITTER1            ( 0.0                ),
   .STARTUP_WAIT           ( "FALSE"            )
)
u_clk_24m
(
   // Clock Outputs: 1-bit (each) output: User configurable clock outputs
   .CLKOUT0                ( clk_24m            ),
   .CLKOUT0B               ( ),
   // Feedback Clocks: 1-bit (each) output: Clock feedback ports
   .CLKFBOUT               ( clk_24m_fb         ),
   .CLKFBOUTB              ( ),
   // Status Ports: 1-bit (each) output: MMCM status ports
   .LOCKED                 ( ),
   // Clock Inputs: 1-bit (each) input: Clock input
   .CLKIN1                 ( sys_clk_50m        ),
   // Control Ports: 1-bit (each) input: MMCM control ports
   .PWRDWN                 ( 1'b0               ),
   .RST                    ( 1'b0               ),
   // Feedback Clocks: 1-bit (each) input: Clock feedback ports
   .CLKFBIN                ( clk_24m_fb         )
);

cam_in_wrapper u_cam_in_wrapper
(
	.clk_24m               ( clk_24m             ),//24MHz
	.cam_vsync             ( cam_vsync           ),//camera vsync
	.cam_href              ( cam_href            ),//camera hsync refrence
	.cam_pclk              ( cam_pclk            ),//camera pxiel clock
	.cam_data              ( cam_data            ),//camera data
	.cam_scl               ( cam_scl             ),//camera i2c clock
	.cam_sda               ( cam_sda             ),//camera i2c data
	.cam_rst_n             ( cam_rst_n           ),//camera reset
	.cam_xclk              ( cam_xclk            ),
	.cam_pwdn              ( cam_pwdn            ),
	.aclk                  ( clk_140m            ),//AXI4-Stream clock
	.aclken                ( 1'b1                ),//AXI4-Stream clock enable
	.aresetn               ( 1'b1                ),//AXI4-Stream reset, active low 
	.axis_enable           ( 1'b1                ),//AXI4-Stream locked
	.m_axis_video_tdata    ( m_axis_video_tdata  ),//AXI4-Stream data
	.m_axis_video_tvalid   ( m_axis_video_tvalid ),//AXI4-Stream valid 
	.m_axis_video_tready   ( m_axis_video_tready ),//AXI4-Stream ready 
	.m_axis_video_tuser    ( m_axis_video_tuser  ),//AXI4-Stream tuser (SOF)
	.m_axis_video_tlast    ( m_axis_video_tlast  ),//AXI4-Stream tlast (EOL)
	.m_axis_video_tkeep    ( ),// AXI4-Stream tkeep
	.fid                   ( )  
);	

system_wrapper u_bd_wrapper
(
   //DDR interface
   .DDR_addr               ( DDR_addr           ),
   .DDR_ba                 ( DDR_ba             ),
   .DDR_cas_n              ( DDR_cas_n          ),
   .DDR_ck_n               ( DDR_ck_n           ),
   .DDR_ck_p               ( DDR_ck_p           ),
   .DDR_cke                ( DDR_cke            ),
   .DDR_cs_n               ( DDR_cs_n           ),
   .DDR_dm                 ( DDR_dm             ),
   .DDR_dq                 ( DDR_dq             ),
   .DDR_dqs_n              ( DDR_dqs_n          ),
   .DDR_dqs_p              ( DDR_dqs_p          ),
   .DDR_odt                ( DDR_odt            ),
   .DDR_ras_n              ( DDR_ras_n          ),
   .DDR_reset_n            ( DDR_reset_n        ),
   .DDR_we_n               ( DDR_we_n           ),
   //fixed_io interface
   .FIXED_IO_ddr_vrn       ( FIXED_IO_ddr_vrn   ),
   .FIXED_IO_ddr_vrp       ( FIXED_IO_ddr_vrp   ),
   .FIXED_IO_mio           ( FIXED_IO_mio       ),
   .FIXED_IO_ps_clk        ( FIXED_IO_ps_clk    ),
   .FIXED_IO_ps_porb       ( FIXED_IO_ps_porb   ),
   .FIXED_IO_ps_srstb      ( FIXED_IO_ps_srstb  ),
   .HDMI_OEN               ( HDMI_OEN           ),
   //S2MM interface
   .S_AXIS_S2MM_tdata      ( m_axis_video_tdata ),
   .S_AXIS_S2MM_tkeep      ( 4'b1111            ),
   .S_AXIS_S2MM_tlast      ( m_axis_video_tlast ),
   .S_AXIS_S2MM_tready     ( m_axis_video_tready),
   .S_AXIS_S2MM_tuser      ( m_axis_video_tuser ),
   .S_AXIS_S2MM_tvalid     ( m_axis_video_tvalid),
   //HDMI interface
   .clk_140m               ( clk_140m           ),
   .hdmi_hpd_tri_i         ( hdmi_hpd_tri_i     ),
   .hdmi_ddc_scl_io        ( hdmi_ddc_scl       ),
   .hdmi_ddc_sda_io        ( hdmi_ddc_sda       ),
   .iic_0_scl_io           ( eeprom_scl         ),
   .iic_0_sda_io           ( eeprom_sda         ),
   //vid out interface
   .LOCKED_O               ( dynclk_lock_o      ),
   .PXL_CLK_5X_O           ( pix_clk_5x         ),
   .PXL_CLK_O              ( pix_clk            ),
   .vid_io_out_active_video( active_video       ),
   .vid_io_out_data        ( video_data         ),
   .vid_io_out_field       ( video_field        ),
   .vid_io_out_hblank      ( ),
   .vid_io_out_hsync       ( video_hsync        ),
   .vid_io_out_vblank      ( ),
   .vid_io_out_vsync       ( video_vsync        )
);

rgb2dvi u_rgb2dvi
(
   .PixelClk                ( pix_clk           ),
   .SerialClk               ( pix_clk_5x        ),
   .aRst                    ( ),
   .aRst_n                  ( dynclk_lock_o     ),
   .vid_pData               ( video_data        ),
   .vid_pVDE                ( active_video      ),
   .vid_pHSync              ( video_hsync       ),
   .vid_pVSync              ( video_vsync       ),
   .TMDS_Clk_p              ( TMDS_clk_p        ),
   .TMDS_Clk_n              ( TMDS_clk_n        ),
   .TMDS_Data_p             ( TMDS_data_p       ),
   .TMDS_Data_n             ( TMDS_data_n       )
);

led_indicator	
#(
   .SET_TIME_1S            ( 50_000_000         ),
   .LED_NUM                ( 1                  )
)
u_led_indicator							
(
	.clk                    ( sys_clk_50m        ),
   .rst                    ( 1'b0               ),
	.led                    ( led_indc           )
);

endmodule