//*****************************************************************************
// dynclk.c
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
#include "dynclk.h"
#include "xil_io.h"
#include "math.h"

//=============================================================================
// Procedure Definitions	
//=============================================================================
u32 ClkCountCalc(u32 divide)
{
	u32 output = 0;
	u32 divCalc = 0;

	divCalc = ClkDivider(divide);
	if (divCalc == ERR_CLKDIVIDER)
		output = ERR_CLKCOUNTCALC;
	else
		output = (0xFFF & divCalc) | ((divCalc << 10) & 0x00C00000);
	return output;
}

u32 ClkDivider(u32 divide)
{
	u32 output = 0;
	u32 highTime = 0;
	u32 lowTime = 0;

	if ((divide < 1) || (divide > 128))
   {
		return ERR_CLKDIVIDER;
   }
	if (divide == 1)
   {
		return 0x1041;
   }
	highTime = divide / 2;
	if (divide & 0b1) //if divide is odd
	{
		lowTime = highTime + 1;
		output = 1 << CLK_BIT_WEDGE;
	}
	else
	{
		lowTime = highTime;
	}

	output |= 0x03F & lowTime;
	output |= 0xFC0 & (highTime << 6);
	return output;
}

u32 ClkFindReg (ClkConfig *regValues, ClkMode *clkParams)
{
	if ((clkParams->fbmult < 2) || clkParams->fbmult > 64 )
   {
		return 0;
   }

	regValues->clk0L = ClkCountCalc(clkParams->clkdiv);
	if (regValues->clk0L == ERR_CLKCOUNTCALC)
   {
		return 0;
   }

	regValues->clkFBL = ClkCountCalc(clkParams->fbmult);
	if (regValues->clkFBL == ERR_CLKCOUNTCALC)
   {
		return 0;
   }

	regValues->clkFBH_clk0H = 0;

	regValues->divclk = ClkDivider(clkParams->maindiv);
	if (regValues->divclk == ERR_CLKDIVIDER)
   {
		return 0;
   }

	regValues->lockL = (u32) (lock_lookup[clkParams->fbmult - 1] & 0xFFFFFFFF);

	regValues->fltr_lockH = (u32) ((lock_lookup[clkParams->fbmult - 1] >> 32) & 0x000000FF);
	regValues->fltr_lockH |= ((filter_lookup_low[clkParams->fbmult - 1] << 16) & 0x03FF0000);

	return 1;
}

void ClkWriteReg (ClkConfig *regValues, u32 dynClkAddr)
{
	Xil_Out32(dynClkAddr + OFST_DYNCLK_CLK_L, regValues->clk0L);
	Xil_Out32(dynClkAddr + OFST_DYNCLK_FB_L, regValues->clkFBL);
	Xil_Out32(dynClkAddr + OFST_DYNCLK_FB_H_CLK_H, regValues->clkFBH_clk0H);
	Xil_Out32(dynClkAddr + OFST_DYNCLK_DIV, regValues->divclk);
	Xil_Out32(dynClkAddr + OFST_DYNCLK_LOCK_L, regValues->lockL);
	Xil_Out32(dynClkAddr + OFST_DYNCLK_FLTR_LOCK_H, regValues->fltr_lockH);
}

/*
 * TODO:This function currently requires that the reference clock is 100MHz.
 * 		This should be changed so that the ref. clock can be specified, or read directly
 * 		out of hardware. This has been done in the linux driver, it just needs to be
 * 		ported here.
 */
double ClkFindParams(double freq, ClkMode *bestPick)
{
	double bestError = 2000.0;
	double curError;
	double curClkMult;
	double curFreq;
	u32 curDiv, curFb, curClkDiv;
	u32 minFb = 0;
	u32 maxFb = 0;

	/*
	 * This is necessary because the MMCM actual is generating 5x the desired pixel clock, and that
	 * clock is then run through a BUFR that divides it by 5 to generate the pixel clock. Note this
	 * means the pixel clock is on the Regional clock network, not the global clock network. In the
	 * future if options like these are parameterized in the axi_dynclk core, then this function will
	 * need to change.
	 */
	freq = freq * 5.0;

	bestPick->freq = 0.0;
//TODO: replace with a smarter algorithm that doesn't doesn't check every possible combination
	for (curDiv = 1; curDiv <= 10; curDiv++)
	{
		minFb = curDiv * 6; //This accounts for the 100MHz input and the 600MHz minimum VCO
		maxFb = curDiv * 12; //This accounts for the 100MHz input and the 1200MHz maximum VCO
		if (maxFb > 64)
			maxFb = 64;

		curClkMult = (100.0 / (double) curDiv) / freq; //This multiplier is used to find the best clkDiv value for each FB value

		curFb = minFb;
		while (curFb <= maxFb)
		{
			curClkDiv = (u32) ((curClkMult * (double)curFb) + 0.5);
			curFreq = ((100.0 / (double) curDiv) / (double) curClkDiv) * (double) curFb;
			curError = fabs(curFreq - freq);
			if (curError < bestError)
			{
				bestError = curError;
				bestPick->clkdiv = curClkDiv;
				bestPick->fbmult = curFb;
				bestPick->maindiv = curDiv;
				bestPick->freq = curFreq;
			}

			curFb++;
		}
	}
//We want the ClkMode struct and errors to be based on the desired frequency. Need to check this doesn't introduce rounding errors.
	bestPick->freq = bestPick->freq / 5.0;
	bestError = bestError / 5.0;
	return bestError;
}

void ClkStart(u32 dynClkAddr)
{
	Xil_Out32(dynClkAddr + OFST_DYNCLK_CTRL, (1 << BIT_DYNCLK_START));
	while(!(Xil_In32(dynClkAddr + OFST_DYNCLK_STATUS) & (1 << BIT_DYNCLK_RUNNING)));

	return;
}

void ClkStop(u32 dynClkAddr)
{
	Xil_Out32(dynClkAddr + OFST_DYNCLK_CTRL, 0);
	while((Xil_In32(dynClkAddr + OFST_DYNCLK_STATUS) & (1 << BIT_DYNCLK_RUNNING)));

	return;
}
