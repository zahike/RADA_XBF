`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 02:43:24 PM
// Design Name: 
// Module Name: Multi_line
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

module Multi_line(
input clk ,
input rstn,

  input   [127:0]M_AXIS_MM2S_0_tdata,
  input   M_AXIS_MM2S_0_tvalid,
  
  input [4:0] MemRDcount,
  
  input        SampleValid,
  input [63:0] Sampledata,
  input        CalcOn,
  
  output[31:0] OutSumr, 
  output[31:0] OutSumi 
    );

reg [31:0] LineMEM [0:64];
reg [31:0] Out_LineMEM;
reg [5:0] MemWRcount;
always @(posedge clk or negedge rstn)
	if (!rstn) MemWRcount <= 5'h00;
     else if (M_AXIS_MM2S_0_tvalid) MemWRcount <= MemWRcount + 1;	
always @(posedge clk) 
	if (M_AXIS_MM2S_0_tvalid) LineMEM[MemWRcount] <= M_AXIS_MM2S_0_tdata[31:0];
always @(posedge clk) 	
	Out_LineMEM <= LineMEM[MemRDcount];
reg [63:0] Sampledata1;
reg [63:0] Sampledata2;
always @(posedge clk or negedge rstn)
	if (!rstn) begin 
		 Sampledata1 <= 64'h0000000000000000;
		 Sampledata2 <= 64'h0000000000000000;
			end 
	 else  begin 
		 Sampledata1 <= Sampledata;
		 Sampledata2 <= Sampledata1;
			end 
wire [31:0] Mulr;	
wire [31:0] Muli;	
Compx_4_Mull Compx_4_Mull_inst(
.clk(clk) ,

.ar(Sampledata1[24: 0]),
.ai(Sampledata1[56:32]),
.br(Out_LineMEM[15: 0]),
.bi(Out_LineMEM[31:16]),
.pr(Mulr),    
.pi(Muli)
);

reg [31:0] Sumr;	
reg [31:0] Sumi;	
always @(posedge clk or negedge rstn)
    if (!rstn) begin 
         Sumr <= 32'h00000000;	
         Sumi <= 32'h00000000;	
            end
     else if (!(SampleValid || CalcOn)) begin 
         Sumr <= 32'h00000000;	
         Sumi <= 32'h00000000;	
            end
     else  begin 
         Sumr <= Sumr + Mulr;	
         Sumi <= Sumi + Muli;	
            end

  assign OutSumr = Sumr; 
  assign OutSumi = Sumi;

endmodule
