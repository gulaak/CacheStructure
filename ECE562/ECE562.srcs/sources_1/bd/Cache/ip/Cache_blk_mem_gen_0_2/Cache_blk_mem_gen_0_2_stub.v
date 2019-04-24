// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sat Mar  9 13:44:22 2019
// Host        : DESKTOP-T2T1KVN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Aiden/Desktop/ECE562/ECE562.srcs/sources_1/bd/Cache/ip/Cache_blk_mem_gen_0_2/Cache_blk_mem_gen_0_2_stub.v
// Design      : Cache_blk_mem_gen_0_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku035-fbva900-1L-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module Cache_blk_mem_gen_0_2(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[18:0],dina[31:0],douta[31:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [18:0]addra;
  input [31:0]dina;
  output [31:0]douta;
endmodule
