`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 07:51:09 PM
// Design Name: 
// Module Name: RFemu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RFemu(
input clk ,
input rstn,

input Start,

  input   [127:0]M_AXIS_MM2S_0_tdata,
  input   [15:0]M_AXIS_MM2S_0_tkeep,
  input   M_AXIS_MM2S_0_tlast,
  output  M_AXIS_MM2S_0_tready,
  input   M_AXIS_MM2S_0_tvalid,

output [127:0] RFemu_data,
output RFemu_valid,
input  RFemu_ready 
    );

reg [127:0] RFdata [0:64];
reg [127:0] Out_RFdata;
reg [5:0] MemWRcount;
reg [5:0] MemRDcount;
always @(posedge clk or negedge rstn) 
	if (!rstn) MemWRcount <= 6'h00;
	 else if (M_AXIS_MM2S_0_tvalid && M_AXIS_MM2S_0_tready) MemWRcount <= MemWRcount + 1;
always @(posedge clk) 
	if (M_AXIS_MM2S_0_tvalid && M_AXIS_MM2S_0_tready) RFdata[MemWRcount] <= M_AXIS_MM2S_0_tdata;
always @(posedge clk) 	
	Out_RFdata <= RFdata[MemRDcount];

assign  M_AXIS_MM2S_0_tready = 1'b1;

reg RdOn;
reg [3:0] RdVl;
always @(posedge clk or negedge rstn)
	if (!rstn) RdOn <= 1'b0;
	 else if (Start && !RdOn) RdOn <= 1'b1;
	 else if (MemRDcount == MemWRcount-1)RdOn <= 1'b0;
always @(posedge clk or negedge rstn)
	if (!rstn) RdVl <= 4'h0;
	 else  RdVl <= {RdVl[2:0],RdOn};
	 
always @(posedge clk or negedge rstn)
	if (!rstn) MemRDcount <= 6'h00;
	 else if (Start) MemRDcount <= 6'h00;
	 else if (RFemu_ready && RdOn) MemRDcount <= MemRDcount+ 1;
	 
assign RFemu_data  = Out_RFdata;
assign RFemu_valid = RdVl[0] && RdVl[1];
endmodule
