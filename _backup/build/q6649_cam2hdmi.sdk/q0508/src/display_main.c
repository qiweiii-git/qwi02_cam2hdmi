//*****************************************************************************
// display_main.c
// 
// Qiwei.Wu
// May 2, 2018
//
// Revision 
// 0.01 - File Created
//*****************************************************************************

//=============================================================================
// include
//=============================================================================
#include "display_main.h"
#include "display_ctrl/display_ctrl.h"
#include "stdio.h"
#include "math.h"
#include "ctype.h"
#include "stdlib.h"
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xiicps.h"
#include "cam_config.h"
#include "vdma.h"

//=============================================================================
// XPAR redefines
//=============================================================================
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#define VGA_VDMA_ID XPAR_AXIVDMA_0_DEVICE_ID
#define DISP_VTC_ID XPAR_VTC_0_DEVICE_ID
#define VID_VTC_IRPT_ID XPS_FPGA3_INT_ID
#define VID_GPIO_IRPT_ID XPS_FPGA4_INT_ID
#define SCU_TIMER_ID XPAR_SCUTIMER_DEVICE_ID
#define UART_BASEADDR XPAR_PS7_UART_1_BASEADDR

//=============================================================================
// Global Variables
//=============================================================================
//Display Driver structs
DisplayCtrl dispCtrl;
XAxiVdma vdma;

//Framebuffers for video data
//#pragma pack(push)
//#pragma pack(8)

u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
//#pragma pack(pop)
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers

//=============================================================================
// Procedure Definitions	
//=============================================================================
int main(void)
{
	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;
	u8 test;

   //Initialize an array of pointers to the 3 frame buffers
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}
	//sensor_init();//initialize ov5640

	//Initialize VDMA driver
	vdmaConfig = XAxiVdma_LookupConfig(VGA_VDMA_ID);
	if (!vdmaConfig)
	{
		xil_printf("No video DMA found for ID %d\r\n", VGA_VDMA_ID);
	}
	Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);
	}

	//Initialize the Display controller and start it
	Status = DisplayInitialize(&dispCtrl, &vdma, DISP_VTC_ID, DYNCLK_BASEADDR,pFrames, DEMO_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);
	}
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);
	}
	//vdma_test1(0x10000000,dispCtrl.framePtr[dispCtrl.curFrame],dispCtrl.framePtr[dispCtrl.curFrame]);
	memset(dispCtrl.framePtr[dispCtrl.curFrame], 0, 1920 * 1080 * 4);//clear display cache
	vdma_write_init(XPAR_AXIVDMA_1_DEVICE_ID,1280 * 4,720,1920 * 4,dispCtrl.framePtr[dispCtrl.curFrame]);

	return 0;
}
