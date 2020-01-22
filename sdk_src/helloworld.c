//////////////////////////////////////////////////////////////////////////////////
//
// Company:        Xilinx
// Engineer:       bwiec
// Create Date:    30 June 2015, 02:37:56 PM
// App Name:       Polled-mode AXI DMA Demonstration
// File Name:      helloworld.c
// Target Devices: Zynq
// Tool Versions:  2015.1
// Description:    Implementation of AXI DMA passthrough
// Dependencies:
//   - xuartps_hw.h - Driver version v3.0
//   - xllfifo.h    - Driver version v4.0
//   - adc.h        - Driver version v1.0
//   - dac.h        - Driver version v1.0
// Revision History:
//   - v1.0
//     * Initial release
//     * Tested on ZC702 and Zedboard
// Additional Comments:
//   - UART baud rate is 115200
//   - In this design, the 'ADC' and 'DAC' devices are simply emulating such
//     hardware (using a GPIO for control). Their purpose is to showcase a
//     middleware driver sitting on top of the dma_passthrough driver. The ADC and
//     DAC drivers will surely need to be re-written for the specific application.
//
//////////////////////////////////////////////////////////////////////////////////

// Includes
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xuartps_hw.h"
#include "xadcps.h"
//#include "xllfifo.h"
#include "xil_cache.h"
#include "adc.h"

// Defines
#define SAMPLES_PER_FRAME  128
#define DATA_CORRECT       0
#define DATA_INCORRECT    -1

// Function prototypes
//void process_data(int samples_per_frame, int* dst, int* src);
//int verify_data(XLlFifo* p_axis_fifo_inst, int frm_idx);

XAdcPs XAdc;
XAdcPs_Config* ConfigPtr;
// Main entry point
int main()
{
	// Local variables
	int     status;
	int     ii = 0, jj = 0, cnt = 0;
	adc_t*  p_adc_inst;
	int     rcv_buf[SAMPLES_PER_FRAME];
	float 	voltages[SAMPLES_PER_FRAME];

	// Setup UART and caches
    init_platform();
    xil_printf("Hello World!!!\n\r");

    u32 res;
   	ConfigPtr = XAdcPs_LookupConfig(XPAR_PS7_XADC_0_DEVICE_ID);
   	if(ConfigPtr == NULL)
   	{
   		xil_printf("Invalid XADC configuration!");
   		return XST_FAILURE;
   	}
   	XAdcPs_CfgInitialize(&XAdc, ConfigPtr, ConfigPtr->BaseAddress);
   	if(XAdcPs_SelfTest(&XAdc) != XST_SUCCESS)
   	{
   		xil_printf("Self test failed!");
   		return XST_FAILURE;
   	}
   	XAdcPs_Reset(&XAdc);


    p_adc_inst = adc_create
    (
    	XPAR_GPIO_0_DEVICE_ID,
    	XPAR_AXIDMA_0_DEVICE_ID,
    	sizeof(int)
    );
    if (p_adc_inst == NULL)
    {
    	xil_printf("ERROR! Failed to create ADC instance.\n\r");
    	return -1;
    }
    // Set the desired parameters for the ADC objects
    adc_set_bytes_per_sample(p_adc_inst, sizeof(int));
    adc_set_samples_per_frame(p_adc_inst, SAMPLES_PER_FRAME);


	// Enable/initialize and dac
	adc_enable(p_adc_inst);

	// Process data
	xil_printf("Starting data processing...\n\r");
	for (ii = 0; 1; ii++)
	{

		xil_printf("========= Frame %d =========\n\r", ii);
		// Get new frame from ADC
		status = adc_get_frame(p_adc_inst, rcv_buf);
		if (status != ADC_SUCCESS) {
			xil_printf("ERROR! Failed to get a new frame of data from the ADC.\n\r");
			return -1;
		}

		// *********************** Insert your code here ***********************
		for (jj = 0; jj < SAMPLES_PER_FRAME; jj++) {
			//CALLIBRATION A LA MAIN
			voltages[jj] = XAdcPs_RawToVoltage(rcv_buf[jj] / 3);
			printf("%04d. %2.2f V\n", cnt, voltages[jj]);
			cnt = (cnt + 1) % 10000;
		}

		xil_printf("Frame %d completed without errors.\n\r", ii);
		for (jj = 0; jj < 0xFFfFFF; jj++);
	}
	adc_destroy(p_adc_inst);

    return 0;

}
