//*****************************************************************************
// display_ctrl.h
// 
// Qiwei.Wu
// May 2, 2018
//
// Revision 
// 0.01 - File Created
//*****************************************************************************

#ifndef DISPLAY_CTRL_H_
#define DISPLAY_CTRL_H_

//=============================================================================
// include
//=============================================================================
#include "xil_types.h"
#include "vga_modes.h"
#include "xaxivdma.h"
#include "xvtc.h"
#include "../dynclk/dynclk.h"

//=============================================================================
// Miscellaneous Declarations
//=============================================================================
#define BIT_DISPLAY_RED 16
#define BIT_DISPLAY_BLUE 8
#define BIT_DISPLAY_GREEN 0
#define DISPLAY_NUM_FRAMES 3

//=============================================================================
// General Type Declarations	
//=============================================================================
typedef enum {
	DISPLAY_STOPPED = 0,
	DISPLAY_RUNNING = 1
} DisplayState;

typedef struct {
		u32 dynClkAddr; /*Physical Base address of the dynclk core*/
		XAxiVdma *vdma; /*VDMA driver struct*/
		XAxiVdma_DmaSetup vdmaConfig; /*VDMA channel configuration*/
		XVtc vtc; /*VTC driver struct*/
		VideoMode vMode; /*Current Video mode*/
		u8 *framePtr[DISPLAY_NUM_FRAMES]; /* Array of pointers to the framebuffers */
		u32 stride; /* The line stride of the framebuffers, in bytes */
		double pxlFreq; /* Frequency of clock currently being generated */
		u32 curFrame; /* Current frame being displayed */
		DisplayState state; /* Indicates if the Display is currently running */
} DisplayCtrl;

//=============================================================================
// Procedure Definitions	
//=============================================================================
int DisplayStop(DisplayCtrl *dispPtr);
int DisplayStart(DisplayCtrl *dispPtr);
int DisplayInitialize(DisplayCtrl *dispPtr, XAxiVdma *vdma, u16 vtcId, u32 dynClkAddr, u8 *framePtr[DISPLAY_NUM_FRAMES], u32 stride);
int DisplaySetMode(DisplayCtrl *dispPtr, const VideoMode *newMode);
int DisplayChangeFrame(DisplayCtrl *dispPtr, u32 frameIndex);

#endif /* DISPLAY_CTRL_H_ */

