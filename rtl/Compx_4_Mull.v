`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 01:43:36 AM
// Design Name: 
// Module Name: Compx_4_Mull
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
module Compx_4_Mull(
input clk ,

input [24:0] ar,
input [24:0] ai,
input [15:0] br,
input [15:0] bi,
input [31:0] pr,    
input [31:0] pi
);

reg signed [24:0]	ar_d, ai_d;
reg signed [15:0]	br_d, bi_d;
always @(posedge clk)
  begin
    ar_d <= ar;
    ai_d <= ai;
    br_d <= br;
    bi_d <= bi;
  end
reg signed [40:0]	arbr;
reg signed [40:0]	arbi;
reg signed [40:0]	aibr;
reg signed [40:0]	aibi;
always @(posedge clk)
 begin
    arbr <= ar_d*br_d;
    arbi <= ar_d*bi_d;
    aibr <= ai_d*br_d;
    aibi <= ai_d*bi_d;
 end
reg signed [40:0]	Mulr;
reg signed [40:0]	Muli;

always @(posedge clk)
 begin
    Mulr <= arbr - aibi;
    Muli <= arbi + aibr;
 end
assign pr = Mulr[40:9];    
assign pi = Muli[40:9];

endmodule