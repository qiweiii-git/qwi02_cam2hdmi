//*****************************************************************************
// vdma.h
// 
// Qiwei.Wu
// May 2, 2018
//
// This procedure used for control the VDMA read and write
//
// Revision 
// 0.01 - File Created
//*****************************************************************************

#ifndef VDMA_H_
#define VDMA_H_

//=============================================================================
// include
//=============================================================================
#include "xaxivdma.h"

//=============================================================================
// Procedure Definitions	
//=============================================================================
int vdma_read_init(short DeviceID,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr);
int vdma_write_init(short DeviceID,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr);
u32 vdma_version();

#endif /* VDMA_H_ */
