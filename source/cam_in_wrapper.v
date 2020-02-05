//*****************************************************************************
// cam_in_wrapper.v
// 
// Qiwei.Wu
// May 7, 2018
//
// This module is the wrapper of the camera video data in.
// Revision 
// 0.01 - File Created
// 1.0  - Release
// 1.1  - Added led_indicator - false
// 2.0  - Connect the clk_24m to the cam_xclk
//*****************************************************************************

module cam_in_wrapper
#(
   parameter AXIS_TDATA_WIDTH = 32
)
(
	input                              clk_24m            ,//24MHz
	input                              cam_vsync          ,//camera vsync
	input                              cam_href           ,//camera hsync refrence
	input                              cam_pclk           ,//camera pxiel clock
	input  [9:2]                       cam_data           ,//camera data
	inout                              cam_scl            ,//camera i2c clock
	inout                              cam_sda            ,//camera i2c data
	output                             cam_rst_n          ,//camera reset
	output                             cam_xclk           ,
	output                             cam_pwdn           ,
	//axi4-stream interface
	input                              aclk               ,//AXI4-Stream clock
	input                              aclken             ,//AXI4-Stream clock enable
	input                              aresetn            ,//AXI4-Stream reset, active low 
	input                              axis_enable        ,//AXI4-Stream locked
	output [AXIS_TDATA_WIDTH-1:0]      m_axis_video_tdata ,//AXI4-Stream data
	output 		                       m_axis_video_tvalid,//AXI4-Stream valid 
	input  	                           m_axis_video_tready,//AXI4-Stream ready 
	output 		                       m_axis_video_tuser ,//AXI4-Stream tuser (SOF)
	output 		                       m_axis_video_tlast ,//AXI4-Stream tlast (EOL)
	output [1:0]                       m_axis_video_tkeep ,// AXI4-Stream tkeep
	output                             fid                
);

//*****************************************************************************
// Signals
//*****************************************************************************
wire   [15:0]                    cam_data_16b       ;
wire                             cam_hblank_16b     ;
wire                             cam_href_16b       ;
wire   [AXIS_TDATA_WIDTH-1:0]    vid_in_data        ;
reg    [7:0]                     cam_data_ff0       ;
reg                              cam_href_ff0       ;
reg                              cam_vsync_ff0      ;
wire                             initial_en         ;
 
//*****************************************************************************
// Processes
//*****************************************************************************
assign cam_pwdn = 1'b0;
assign cam_xclk = clk_24m;
assign vid_in_data = {8'h0, cam_data_16b[4:0],3'd0,cam_data_16b[10:5],2'd0,cam_data_16b[15:11],3'd0};
assign m_axis_video_tkeep = 2'b11;

always @(posedge cam_pclk)
begin
   cam_data_ff0  <= cam_data[9:2];
   cam_href_ff0  <= cam_href;
   cam_vsync_ff0 <= cam_vsync;
end

//*****************************************************************************
// Maps
//*****************************************************************************
cam_reset u_cam_reset
(
   .clk                    ( clk_24m            ),//I2C clock 24MHz, 1 clock = 41.666667ns
   .cam_rst_n              ( cam_rst_n          ),//0-reset
   .cam_pwnd               ( ),
   .initial_en             ( initial_en         )
);

reg_config u_iic_config
(     
   .clk_25m                ( clk_24m            ),
   .cam_rstn               ( cam_rst_n          ),
   .initial_en             ( initial_en         ),
   .reg_conf_done          ( ),
   .i2c_sclk               ( cam_scl            ),
   .i2c_sdat               ( cam_sda            )
);

cam_8b16b u_cam_8b16b
(
   .rst                    ( ~cam_rst_n         ),
	.pixel_clk              ( cam_pclk           ),
	.data_i                 ( cam_data_ff0       ),
	.data_de_i              ( cam_href_ff0       ),
	.data_o                 ( cam_data_16b       ),
	.hblank_o               ( cam_hblank_16b     ),
	.data_de_o              ( cam_href_16b       )
);

vid_in_axi4s u_cam_in
(
	//Native video signals
	.vid_io_in_clk          ( cam_pclk           ),//Native video clock
	.vid_io_in_ce           ( 1'b1               ),//Native video clock enable
	.vid_io_in_reset        ( 1'b0               ),//Native video reset active high
	.vid_active_video       ( cam_href_16b       ),//Native video data enable
	.vid_vblank             ( 1'b0               ),//Native video vertical blank
	.vid_hblank             ( cam_hblank_16b     ),//Native video horizontal blank
	.vid_vsync              ( cam_vsync_ff0      ),//Native video vertical sync
	.vid_hsync              ( cam_href_ff0       ),//Native video horizontal sync
	.vid_field_id           ( 1'b0               ),//Native video field-id
	.vid_data               ( vid_in_data        ),//Native video data 
	//AXI4-Stream signals
	.aclk                   ( aclk               ),//AXI4-Stream clock
	.aclken                 ( aclken             ),//AXI4-Stream clock enable
	.aresetn                ( aresetn            ),//AXI4-Stream reset active low 
	.m_axis_video_tdata     ( m_axis_video_tdata ),//AXI4-Stream data
	.m_axis_video_tvalid    ( m_axis_video_tvalid),//AXI4-Stream valid 
	.m_axis_video_tready    ( m_axis_video_tready),//AXI4-Stream ready 
	.m_axis_video_tuser     ( m_axis_video_tuser ),//AXI4-Stream tuser (SOF)
	.m_axis_video_tlast     ( m_axis_video_tlast ),//AXI4-Stream tlast (EOL)
	.fid                    ( fid                ),//Field-id output
	//Video timing detector locked
	.axis_enable            ( axis_enable        )
);

endmodule 