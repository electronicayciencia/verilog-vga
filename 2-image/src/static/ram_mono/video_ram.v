//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8
//Part Number: GW1N-LV1QN48C6/I5
//Device: GW1N-1
//Created Time: Sun Dec 05 19:16:45 2021

module video_ram (dout, clka, cea, reseta, clkb, ceb, resetb, oce, ada, din, adb);

output [0:0] dout;
input clka;
input cea;
input reseta;
input clkb;
input ceb;
input resetb;
input oce;
input [15:0] ada;
input [0:0] din;
input [15:0] adb;

wire [30:0] sdpb_inst_0_dout_w;
wire [0:0] sdpb_inst_0_dout;
wire [30:0] sdpb_inst_1_dout_w;
wire [0:0] sdpb_inst_1_dout;
wire [30:0] sdpb_inst_2_dout_w;
wire [0:0] sdpb_inst_2_dout;
wire [30:0] sdpb_inst_3_dout_w;
wire [0:0] sdpb_inst_3_dout;
wire dff_q_0;
wire dff_q_1;
wire mux_o_0;
wire mux_o_1;
wire gw_gnd;

assign gw_gnd = 1'b0;

SDPB sdpb_inst_0 (
    .DO({sdpb_inst_0_dout_w[30:0],sdpb_inst_0_dout[0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,ada[15],ada[14]}),
    .BLKSELB({gw_gnd,adb[15],adb[14]}),
    .ADA(ada[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[0]}),
    .ADB(adb[13:0])
);

defparam sdpb_inst_0.READ_MODE = 1'b0;
defparam sdpb_inst_0.BIT_WIDTH_0 = 1;
defparam sdpb_inst_0.BIT_WIDTH_1 = 1;
defparam sdpb_inst_0.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_0.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_0.RESET_MODE = "SYNC";

SDPB sdpb_inst_1 (
    .DO({sdpb_inst_1_dout_w[30:0],sdpb_inst_1_dout[0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,ada[15],ada[14]}),
    .BLKSELB({gw_gnd,adb[15],adb[14]}),
    .ADA(ada[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[0]}),
    .ADB(adb[13:0])
);

defparam sdpb_inst_1.READ_MODE = 1'b0;
defparam sdpb_inst_1.BIT_WIDTH_0 = 1;
defparam sdpb_inst_1.BIT_WIDTH_1 = 1;
defparam sdpb_inst_1.BLK_SEL_0 = 3'b001;
defparam sdpb_inst_1.BLK_SEL_1 = 3'b001;
defparam sdpb_inst_1.RESET_MODE = "SYNC";

SDPB sdpb_inst_2 (
    .DO({sdpb_inst_2_dout_w[30:0],sdpb_inst_2_dout[0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,ada[15],ada[14]}),
    .BLKSELB({gw_gnd,adb[15],adb[14]}),
    .ADA(ada[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[0]}),
    .ADB(adb[13:0])
);

defparam sdpb_inst_2.READ_MODE = 1'b0;
defparam sdpb_inst_2.BIT_WIDTH_0 = 1;
defparam sdpb_inst_2.BIT_WIDTH_1 = 1;
defparam sdpb_inst_2.BLK_SEL_0 = 3'b010;
defparam sdpb_inst_2.BLK_SEL_1 = 3'b010;
defparam sdpb_inst_2.RESET_MODE = "SYNC";

SDPB sdpb_inst_3 (
    .DO({sdpb_inst_3_dout_w[30:0],sdpb_inst_3_dout[0]}),
    .CLKA(clka),
    .CEA(cea),
    .RESETA(reseta),
    .CLKB(clkb),
    .CEB(ceb),
    .RESETB(resetb),
    .OCE(oce),
    .BLKSELA({gw_gnd,ada[15],ada[14]}),
    .BLKSELB({gw_gnd,adb[15],adb[14]}),
    .ADA(ada[13:0]),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[0]}),
    .ADB(adb[13:0])
);

defparam sdpb_inst_3.READ_MODE = 1'b0;
defparam sdpb_inst_3.BIT_WIDTH_0 = 1;
defparam sdpb_inst_3.BIT_WIDTH_1 = 1;
defparam sdpb_inst_3.BLK_SEL_0 = 3'b011;
defparam sdpb_inst_3.BLK_SEL_1 = 3'b011;
defparam sdpb_inst_3.RESET_MODE = "SYNC";

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(adb[15]),
  .CLK(clkb),
  .CE(ceb)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(adb[14]),
  .CLK(clkb),
  .CE(ceb)
);
MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(sdpb_inst_0_dout[0]),
  .I1(sdpb_inst_1_dout[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_1 (
  .O(mux_o_1),
  .I0(sdpb_inst_2_dout[0]),
  .I1(sdpb_inst_3_dout[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_2 (
  .O(dout[0]),
  .I0(mux_o_0),
  .I1(mux_o_1),
  .S0(dff_q_0)
);
endmodule //video_ram
