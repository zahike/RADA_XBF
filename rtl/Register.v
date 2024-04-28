`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2024 08:36:15 AM
// Design Name: 
// Module Name: Register
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


module Register(
input clk,
input rstn,

input [31:0] resetValue,
input inWR,
input [31:0] inWRdata,
input [31:0] inRDdata,

output [31:0] outWRdata,
output [31:0] outRDdata
    );

reg [31:0] WRreg;
reg [31:0] RDreg;
always @(posedge clk or negedge rstn)
    if (!rstn) WRreg <= resetValue;
     else if (inWR) WRreg <= inWRdata;
     else WRreg <= RDreg;

always @(posedge clk or negedge rstn)
    if (!rstn) RDreg <= resetValue;
     else RDreg <= inRDdata;

assign outWRdata = WRreg;
assign outRDdata = RDreg;
     
endmodule
