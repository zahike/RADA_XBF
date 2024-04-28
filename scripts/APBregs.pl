#!/bin/perl
if ($#ARGV<1) {
  print "\n*** Bad usage, please use the command as the following line:\n";
  print "APBregs\.pl -InputFile <Input file name> -OutputFile <Output file name>\n";
  print "example:\n APBregs\.pl -InputFile input_file_name\.txt -OutputFile output_file_name\.txt\n";
  exit;
}
$token=$ARGV[0];
while ($ARGV=shift) {
  if ($token =~ /^-InputFile/) {
    print "input_file= $ARGV[0] \t";
    $input_file=$ARGV[0];
  }
  if ($token =~ /^-OutputFile/) {
    print "Block Name : $ARGV[0] \n";
    $OutputFile=$ARGV[0];
  }
  shift;
  $token=$ARGV[0];
}
open (READ_FILE,$input_file) || die "error: Can't open $InstFile ";
#@RegAdd;
#$num = 1;
#	printf "\n\n";

while ($line = <READ_FILE>) {
	@type = split(/,/,$line);
	# printf "@type \n";
	if ($type[3] ne "MSB") 
	{
	$RegNum[$num]     = $type[0];
	$RegAdd[$num]     = $type[1];
	$RegName[$num]    = $type[2];
	$StartBit[$num]   = $type[3];
	$StopBit[$num]    = $type[4];
	$FildName[$num]   = $type[5];
	$RegType[$num]    = $type[6];
	$ResetValue[$num] = $type[7];
	
	printf "$RegNum[$num]      \t ";
	printf "$RegAdd[$num]      \t ";
	printf "$RegName[$num]     \t ";
	printf "$StartBit[$num]    \t ";
	printf "$StopBit[$num]     \t ";
	printf "$FildName[$num]    \t ";
	printf "$RegType[$num]     \t ";
	printf "$ResetValue[$num]  \t ";
	printf "\n";
	$num++;
	}
}

close(READ_FILE);
open (WRITE_FILE,">$OutputFile") || die "error: Can't open $OutputFile ";
printf WRITE_FILE "`timescale 1ns / 1ps                                                                \n";
printf WRITE_FILE "//////////////////////////////////////////////////////////////////////////////////  \n";
printf WRITE_FILE "//                This is an automatic Register file                                \n";
printf WRITE_FILE "// Engineer: Udi Edny                                                               \n";
printf WRITE_FILE "//                                                                                  \n";
printf WRITE_FILE "// Module Name: APB_regs                                                            \n";
printf WRITE_FILE "//                                                                                  \n";
printf WRITE_FILE "//////////////////////////////////////////////////////////////////////////////////  \n";
printf WRITE_FILE "                                                                                    \n";
printf WRITE_FILE "module APB_regs(                                                                    \n";
printf WRITE_FILE "input clk ,                                                                         \n";
printf WRITE_FILE "input rstn,                                                                         \n";
printf WRITE_FILE "\n";
foreach $num (@RegNum){	
#	if ($num > 0){
		if (($RegType[$num] eq "WR") or ($RegType[$num] eq "TR")) {
			printf WRITE_FILE "    output [$StartBit[$num]:$StopBit[$num]] $RegName[$num]$FildName[$num], \n";
		} else {
			printf WRITE_FILE "    input  [$StartBit[$num]:$StopBit[$num]] $RegName[$num]$FildName[$num], \n";
		}
#	}
}
printf WRITE_FILE "\n";
printf WRITE_FILE "  input [31:0]APB_M_0_paddr,                                                        \n";
printf WRITE_FILE "  input APB_M_0_penable,                                                            \n";
printf WRITE_FILE "  output [31:0]APB_M_0_prdata,                                                      \n";
printf WRITE_FILE "  output [0:0]APB_M_0_pready,                                                       \n";
printf WRITE_FILE "  input [0:0]APB_M_0_psel,                                                          \n";
printf WRITE_FILE "  output [0:0]APB_M_0_pslverr,                                                      \n";
printf WRITE_FILE "  input [31:0]APB_M_0_pwdata,                                                       \n";
printf WRITE_FILE "  input APB_M_0_pwrite                                                              \n";
printf WRITE_FILE "    );                                                                              \n";

$OldAdd ;
foreach $num (@RegNum){	
#	if ($num > 0) { 
		if($OldAdd ne $RegAdd[$num]){
printf WRITE_FILE "\n";
printf WRITE_FILE "wire [31:0] resetValue_$RegAdd[$num];\n";
printf WRITE_FILE "wire inWR_$RegAdd[$num] = APB_M_0_penable && APB_M_0_psel && APB_M_0_pwrite && (APB_M_0_paddr[15:0] == 16'h$RegAdd[$num]);\n";
printf WRITE_FILE "wire [31:0] inWRdata_$RegAdd[$num];  \n";
printf WRITE_FILE "wire [31:0] inRDdata_$RegAdd[$num];  \n";
printf WRITE_FILE "wire [31:0] outWRdata_$RegAdd[$num]; \n";
printf WRITE_FILE "wire [31:0] outRDdata_$RegAdd[$num]; \n";
printf WRITE_FILE "Register Register_$RegAdd[$num]_inst(   \n";
printf WRITE_FILE ".clk (clk ),                            \n";
printf WRITE_FILE ".rstn(rstn),                            \n";
printf WRITE_FILE "                                        \n";
printf WRITE_FILE ".resetValue(resetValue_$RegAdd[$num]),  \n";
printf WRITE_FILE ".inWR      (inWR_$RegAdd[$num]),        \n";
printf WRITE_FILE ".inWRdata  (inWRdata_$RegAdd[$num]),    \n";
printf WRITE_FILE ".inRDdata  (inRDdata_$RegAdd[$num]),    \n";
printf WRITE_FILE "		                                   \n";
printf WRITE_FILE ".outWRdata (outWRdata_$RegAdd[$num]),   \n";
printf WRITE_FILE ".outRDdata (outRDdata_$RegAdd[$num])    \n";
printf WRITE_FILE "    );                                  \n";
			}
printf WRITE_FILE "assign resetValue_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\] = $ResetValue[$num];\n";
printf WRITE_FILE "assign inWRdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\] = APB_M_0_pwdata \[$StartBit[$num]\:$StopBit[$num]\]\;\n";
		if ($RegType[$num] eq "TR") {
printf WRITE_FILE "assign $RegName[$num]$FildName[$num] = outWRdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\];\n";
printf WRITE_FILE "assign inRDdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\] = $ResetValue[$num];  \n";
		} elsif ($RegType[$num] eq "WR") {
printf WRITE_FILE "assign $RegName[$num]$FildName[$num] = outWRdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\];\n";
printf WRITE_FILE "assign inRDdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\] = outWRdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\];  \n";
		} else {
printf WRITE_FILE "assign inRDdata_$RegAdd[$num]\[$StartBit[$num]\:$StopBit[$num]\] = $RegName[$num]$FildName[$num];  \n";
		}
#	}	
	$OldAdd = $RegAdd[$num];
}
$OldAdd = 0;
printf WRITE_FILE "\n\n";
printf WRITE_FILE "reg [31:0] ReadData\;\n";
printf WRITE_FILE "reg  readyBit\;\n";
printf WRITE_FILE "always@(posedge clk or negedge rstn)\n";
printf WRITE_FILE "      if (!rstn) begin  \n";
printf WRITE_FILE "           ReadData <= 31'h00000000;\n";
printf WRITE_FILE "           readyBit <= 1'b0;\n";
printf WRITE_FILE "             end \n";
printf WRITE_FILE "       else begin \n";
printf WRITE_FILE "           readyBit <= APB_M_0_penable && APB_M_0_psel;\n";
printf WRITE_FILE "           case (APB_M_0_paddr[15:0])  \n";
foreach $num (@RegNum){
#	if ($num > 0) { 
		if($OldAdd ne $RegAdd[$num]){
printf WRITE_FILE "               16'h$RegAdd[$num] :  ReadData <= outRDdata_$RegAdd[$num];\n";
		}
	$OldAdd = $RegAdd[$num];
#	}
}
printf WRITE_FILE "               default :  ReadData <= 31'h00000000;\n";
printf WRITE_FILE "           endcase \n";
printf WRITE_FILE "             end \n";






printf WRITE_FILE "\n";
printf WRITE_FILE "assign APB_M_0_prdata  = ReadData;\n";
printf WRITE_FILE "assign APB_M_0_pready  = readyBit;\n";
printf WRITE_FILE "assign APB_M_0_pslverr = 1'b0;\n";
printf WRITE_FILE "endmodule                     \n";
close(WRITE_FILE);
