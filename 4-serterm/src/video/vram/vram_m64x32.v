//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8.03
//Part Number: GW1N-LV1QN48C6/I5
//Device: GW1N-1
//Created Time: Sat Jan 13 18:14:37 2024

module vram_m64x32 (douta, doutb, clka, ocea, cea, reseta, wrea, clkb, oceb, ceb, resetb, wreb, ada, dina, adb, dinb);

output [8:0] douta;
output [8:0] doutb;
input clka;
input ocea;
input cea;
input reseta;
input wrea;
input clkb;
input oceb;
input ceb;
input resetb;
input wreb;
input [10:0] ada;
input [8:0] dina;
input [10:0] adb;
input [8:0] dinb;

wire [8:0] dpx9b_inst_0_douta_w;
wire [8:0] dpx9b_inst_0_doutb_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

DPX9B dpx9b_inst_0 (
    .DOA({dpx9b_inst_0_douta_w[8:0],douta[8:0]}),
    .DOB({dpx9b_inst_0_doutb_w[8:0],doutb[8:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,gw_gnd}),
    .BLKSELB({gw_gnd,gw_gnd,gw_gnd}),
    .ADA({ada[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[8:0]}),
    .ADB({adb[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[8:0]})
);

defparam dpx9b_inst_0.READ_MODE0 = 1'b0;
defparam dpx9b_inst_0.READ_MODE1 = 1'b0;
defparam dpx9b_inst_0.WRITE_MODE0 = 2'b01;
defparam dpx9b_inst_0.WRITE_MODE1 = 2'b00;
defparam dpx9b_inst_0.BIT_WIDTH_0 = 9;
defparam dpx9b_inst_0.BIT_WIDTH_1 = 9;
defparam dpx9b_inst_0.BLK_SEL_0 = 3'b000;
defparam dpx9b_inst_0.BLK_SEL_1 = 3'b000;
defparam dpx9b_inst_0.RESET_MODE = "SYNC";

endmodule //vram_m64x32
