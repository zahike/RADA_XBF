#include <stdio.h>
#include "xparameters.h"
#include "xaxidma.h"

#define MEM_BASE_ADDR		XPAR_BRAM_2_BASEADDR
#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00001000)

u32 *APB = XPAR_APB_M_0_BASEADDR;
XAxiDma AxiDma;
u32 Coefficiant[] = {
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000,
		0x00000001, 0x00000000, 0x00000000, 0x00000000,
		0x00000002, 0x00000000, 0x00000000, 0x00000000
};

u32 SampleData[] = {
		0x00004001, 0x00008001, 0x0000C001, 0x00010001,
		0x00014001, 0x00018001, 0x0001C001, 0x00020001,
		0x00004001, 0x00008001, 0x0000C001, 0x00010001,
		0x00014001, 0x00018001, 0x0001C001, 0x00020001,
		0x00004001, 0x00008001, 0x0000C001, 0x00010001,
		0x00014001, 0x00018001, 0x0001C001, 0x00020001,
		0x00004001, 0x00008001, 0x0000C001, 0x00010001,
		0x00014001, 0x00018001, 0x0001C001, 0x00020001,
};
int main()
{
	XAxiDma_Config *CfgPtr;
	int Status;
	u32 *TxBufferPtr;
	int Size;
	int data;

	APB[1] = 0x12345678;
	TxBufferPtr = (u32 *)TX_BUFFER_BASE ;
	Size = sizeof(Coefficiant);
	memcpy (TxBufferPtr,Coefficiant,Size);
	APB[1] = 0x23456788;

	/* Initialize the XAxiDma device.
	 */
	CfgPtr = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
	if (!CfgPtr) {
//		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
//		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(&AxiDma)){
//		xil_printf("Device configured as SG mode \r\n");
		return XST_FAILURE;
	}

	/* Disable interrupts, we use polling mode
	 */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);

	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, Size);

	APB[1] = 0x34567812;
	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr,
			Size, XAXIDMA_DMA_TO_DEVICE);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	while (XAxiDma_Busy(&AxiDma,XAXIDMA_DMA_TO_DEVICE)) {
			/* Wait */
	}

	APB[1] = 0x12345678;
	Size = sizeof(SampleData);
	memcpy (TxBufferPtr,SampleData,Size);
	APB[1] = 0x23456789;

	APB[0] = 0x34567812;
	Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr,
			Size, XAXIDMA_DMA_TO_DEVICE);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	while (XAxiDma_Busy(&AxiDma,XAXIDMA_DMA_TO_DEVICE)) {
			/* Wait */
	}

	APB[0] = 0x1;
	data = APB[0];
	APB[0] = 0x2;
	data = APB[0];
	APB[0] = 0x4;
	data = APB[0];
	APB[1] = 0x12345678;
	data = APB[1];
	APB[2] = 0x23456789;
	data = APB[2];
	APB[3] = 0x3456789a;
	data = APB[3];
	APB[4] = 0x456789ab;
	data = APB[4];
	APB[5] = 0x56789abc;
	data = APB[5];
}
