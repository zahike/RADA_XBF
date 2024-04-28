`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2024 02:14:56 PM
// Design Name: 
// Module Name: XBF_Top
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


module XBF_Top(
  inout [14:0]DDR_addr,
  inout [2:0]DDR_ba,
  inout DDR_cas_n,
  inout DDR_ck_n,
  inout DDR_ck_p,
  inout DDR_cke,
  inout DDR_cs_n,
  inout [3:0]DDR_dm,
  inout [31:0]DDR_dq,
  inout [3:0]DDR_dqs_n,
  inout [3:0]DDR_dqs_p,
  inout DDR_odt,
  inout DDR_ras_n,
  inout DDR_reset_n,
  inout DDR_we_n,
  inout FIXED_IO_ddr_vrn,
  inout FIXED_IO_ddr_vrp,
  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb
    );
    
wire clk;
wire rstn;    
  wire [31:0]APB_M_0_paddr;
  wire APB_M_0_penable;
  wire [31:0]APB_M_0_prdata;
  wire [0:0]APB_M_0_pready;
  wire [0:0]APB_M_0_psel;
  wire [0:0]APB_M_0_pslverr;
  wire [31:0]APB_M_0_pwdata;
  wire APB_M_0_pwrite;
  wire [127:0]M_AXIS_MM2S_0_tdata;
  wire [15:0]M_AXIS_MM2S_0_tkeep;
  wire M_AXIS_MM2S_0_tlast;
  wire M_AXIS_MM2S_0_tready;
  wire M_AXIS_MM2S_0_tvalid;

  XBF_BD XBF_BD_i
       (.APB_M_0_paddr(APB_M_0_paddr),
        .APB_M_0_penable(APB_M_0_penable),
        .APB_M_0_prdata(APB_M_0_prdata),
        .APB_M_0_pready(APB_M_0_pready),
        .APB_M_0_psel(APB_M_0_psel),
        .APB_M_0_pslverr(APB_M_0_pslverr),
        .APB_M_0_pwdata(APB_M_0_pwdata),
        .APB_M_0_pwrite(APB_M_0_pwrite),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(clk),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .M_AXIS_MM2S_0_tdata(M_AXIS_MM2S_0_tdata),
        .M_AXIS_MM2S_0_tkeep(M_AXIS_MM2S_0_tkeep),
        .M_AXIS_MM2S_0_tlast(M_AXIS_MM2S_0_tlast),
        .M_AXIS_MM2S_0_tready(M_AXIS_MM2S_0_tready),
        .M_AXIS_MM2S_0_tvalid(M_AXIS_MM2S_0_tvalid),
        .peripheral_aresetn(rstn));

wire [0:0] ContStart ; 
wire [1:1] ContDMAsel; 
wire [2:2] ContDMA; 
wire [31:0] WRaddWRadd; 
wire [31:0] WRsizeWRsize; 
wire [31:0] RDaddRDadd; 
wire [31:0] RDsizeRDsize; 
wire [31:0] ReadRegReadReg = 31'h12345678; 

APB_regs APB_regs_inst(                                                                    
.clk (clk ),                                                                         
.rstn(rstn),                                                                         

    .ContStart     (ContStart     ), 
    .ContDMAsel    (ContDMAsel    ), 

.APB_M_0_paddr  ({APB_M_0_paddr[15:2],2'b00}),                                                        
.APB_M_0_penable(APB_M_0_penable),                                                            
.APB_M_0_prdata (APB_M_0_prdata ),                                                      
.APB_M_0_pready (APB_M_0_pready ),                                                       
.APB_M_0_psel   (APB_M_0_psel   ),                                                          
.APB_M_0_pslverr(APB_M_0_pslverr),                                                      
.APB_M_0_pwdata (APB_M_0_pwdata ),                                                       
.APB_M_0_pwrite (APB_M_0_pwrite )                                                             
    );                                                                              

wire [127:0] RFemu_data;
wire RFemu_valid       ;
wire RFemu_ready       ;
wire Next_sample       ;

RFemu RFemu_inst(
.clk  (clk  ),
.rstn (rstn ),
     
.Start(ContStart),

.M_AXIS_MM2S_0_tdata (M_AXIS_MM2S_0_tdata ),
.M_AXIS_MM2S_0_tkeep (M_AXIS_MM2S_0_tkeep ),
.M_AXIS_MM2S_0_tlast (M_AXIS_MM2S_0_tlast ),
.M_AXIS_MM2S_0_tready(M_AXIS_MM2S_0_tready),
.M_AXIS_MM2S_0_tvalid(M_AXIS_MM2S_0_tvalid && ContDMAsel),

.RFemu_data (RFemu_data ),
.RFemu_valid(RFemu_valid),
.RFemu_ready(RFemu_ready) 
    );
// Get 128 bits from RFSoc swithc to 64 bits for Multi_Line    
reg SampleOn;
reg SampleValid;
reg [4:0] SampleValid_shift;
reg [4:0] SampleCount;
wire        Sum_Valid;
assign RFemu_ready = (RFemu_valid && !SampleOn)      ? 1'b1 :
                     (SampleCount[0] && RFemu_valid) ? 1'b1 : 1'b0;
assign Next_sample = (~SampleCount[0] && SampleOn  ) ? 1'b1 : 1'b0;
reg [63:0] sampledata1;
reg [63:0] sampledata2;
assign Sum_Valid = (SampleValid_shift == 5'h10) ? 1'b1 : 1'b0;
always @(posedge clk or negedge rstn)
    if (!rstn) begin
         SampleOn    <= 1'b0;
         SampleValid <= 1'b0;
		 SampleValid_shift <= 5'h00;
         SampleCount <= 5'h00;
             end
     else if (SampleOn) begin
            SampleCount <= SampleCount + 1;
			SampleValid_shift <= {SampleValid_shift[3:0],SampleValid}; 
            if (SampleCount == 5'h0f) SampleValid <= 1'b0;
             else if (Sum_Valid) begin
         SampleOn    <= 1'b0;
         SampleCount <= 5'h00;                
                    end
            end
     else if (RFemu_valid && RFemu_ready) begin 
         SampleOn    <= 1'b1;
         SampleValid <= 1'b1;
         SampleCount <= 5'h00;
             end
always @(posedge clk or negedge rstn)
    if (!rstn) begin
          sampledata1 <= 64'h0000000000000000;
          sampledata2 <= 64'h0000000000000000;
            end
     else if (RFemu_ready) begin
            sampledata1 <= RFemu_data[ 63 :  0];
            sampledata2 <= RFemu_data[127 : 64];
                end
         else if (Next_sample) begin 
			sampledata1 <= sampledata2;
			  end
wire[31:0] OutSumr;
wire[31:0] OutSumi;
Multi_line Multi_line_inst(
.clk (clk ),
.rstn(rstn),

.M_AXIS_MM2S_0_tdata (M_AXIS_MM2S_0_tdata ),
.M_AXIS_MM2S_0_tvalid(M_AXIS_MM2S_0_tvalid && !ContDMAsel),

.MemRDcount(SampleCount),

.SampleValid(SampleValid),
.Sampledata (sampledata1 ),
.CalcOn     (SampleValid_shift[4]),

.OutSumr(OutSumr), 
.OutSumi(OutSumi) 
    );

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ila_1 ila_1_inst (
	.clk(clk), // input wire clk

	.probe0(SampleValid), // input wire [0:0]  probe0  
	.probe1(sampledata1), // input wire [62:0]  probe1 
	.probe2(SampleValid_shift), // input wire [4:0]  probe2 
	.probe3(OutSumr), // input wire [31:0]  probe3 
	.probe4(OutSumi) // input wire [31:0]  probe4
);

endmodule
