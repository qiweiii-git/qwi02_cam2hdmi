//*****************************************************************************
// display_main.h
// 
// Qiwei.Wu
// May 2, 2018
//
// Revision 
// 0.01 - File Created
//*****************************************************************************

#ifndef DISPLAY_DEMO_H_
#define DISPLAY_DEMO_H_

//=============================================================================
// include
//=============================================================================
#include "xil_types.h"

//=============================================================================
// Miscellaneous Declarations
//=============================================================================
#define DEMO_PATTERN_0 0
#define DEMO_PATTERN_1 1
#define DEMO_PATTERN_2 2
#define DEMO_PATTERN_3 3
#define DEMO_PATTERN_4 4
#define DEMO_PATTERN_5 5
#define DEMO_MAX_FRAME (1920*1080*4)
#define DEMO_STRIDE (1920 * 4)

//=============================================================================
// Procedure Definitions	
//=============================================================================
void DemoInitialize();
void DemoRun();
void DemoPrintMenu();
void DemoChangeRes();
void DemoCRMenu();
void DemoInvertFrame(u8 *srcFrame, u8 *destFrame, u32 width, u32 height, u32 stride);
void DemoPrintTest(u8 *frame, u32 width, u32 height, u32 stride, int pattern);

#endif /* DISPLAY_DEMO_H_ */
