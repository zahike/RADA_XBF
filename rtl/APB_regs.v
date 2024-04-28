`timescale 1ns / 1ps                                                                
//////////////////////////////////////////////////////////////////////////////////  
//                This is an automatic Register file                                
// Engineer: Udi Edny                                                               
//                                                                                  
// Module Name: APB_regs                                                            
//                                                                                  
//////////////////////////////////////////////////////////////////////////////////  
                                                                                    
module APB_regs(                                                                    
input clk ,                                                                         
input rstn,                                                                         

    output [0:0] ContStart, 
    output [1:1] ContDMAsel, 

  input [31:0]APB_M_0_paddr,                                                        
  input APB_M_0_penable,                                                            
  output [31:0]APB_M_0_prdata,                                                      
  output [0:0]APB_M_0_pready,                                                       
  input [0:0]APB_M_0_psel,                                                          
  output [0:0]APB_M_0_pslverr,                                                      
  input [31:0]APB_M_0_pwdata,                                                       
  input APB_M_0_pwrite                                                              
    );                                                                              

wire [31:0] resetValue_0000;
wire inWR_0000 = APB_M_0_penable && APB_M_0_psel && APB_M_0_pwrite && (APB_M_0_paddr[15:0] == 16'h0000);
wire [31:0] inWRdata_0000;  
wire [31:0] inRDdata_0000;  
wire [31:0] outWRdata_0000; 
wire [31:0] outRDdata_0000; 
Register Register_0000_inst(   
.clk (clk ),                            
.rstn(rstn),                            
                                        
.resetValue(resetValue_0000),  
.inWR      (inWR_0000),        
.inWRdata  (inWRdata_0000),    
.inRDdata  (inRDdata_0000),    
		                                   
.outWRdata (outWRdata_0000),   
.outRDdata (outRDdata_0000)    
    );                                  
assign resetValue_0000[0:0] = 1'b0;
assign inWRdata_0000[0:0] = APB_M_0_pwdata [0:0];
assign ContStart = outWRdata_0000[0:0];
assign inRDdata_0000[0:0] = 1'b0;  
assign resetValue_0000[1:1] = 1'b0;
assign inWRdata_0000[1:1] = APB_M_0_pwdata [1:1];
assign ContDMAsel = outWRdata_0000[1:1];
assign inRDdata_0000[1:1] = outWRdata_0000[1:1];  


reg [31:0] ReadData;
reg  readyBit;
always@(posedge clk or negedge rstn)
      if (!rstn) begin  
           ReadData <= 31'h00000000;
           readyBit <= 1'b0;
             end 
       else begin 
           readyBit <= APB_M_0_penable && APB_M_0_psel;
           case (APB_M_0_paddr[15:0])  
               16'h0000 :  ReadData <= outRDdata_0000;
               default :  ReadData <= 31'h00000000;
           endcase 
             end 

assign APB_M_0_prdata  = ReadData;
assign APB_M_0_pready  = readyBit;
assign APB_M_0_pslverr = 1'b0;
endmodule                     
