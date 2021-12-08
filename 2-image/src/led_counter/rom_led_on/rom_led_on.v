//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8
//Part Number: GW1N-LV1QN48C6/I5
//Device: GW1N-1
//Created Time: Wed Dec 08 22:23:53 2021

module rom_led_on (dout, clk, oce, ce, reset, ad);

output [15:0] dout;
input clk;
input oce;
input ce;
input reset;
input [9:0] ad;

wire [15:0] prom_inst_0_dout_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[15:0],dout[15:0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .AD({ad[9:0],gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 16;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_02 = 256'hA534A51494B28430630C18E30000000000000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_03 = 256'h000000000000000000000000000000000000000018E3630C843094B2A514A534;
defparam prom_inst_0.INIT_RAM_04 = 256'hA534A534A534A534A5349CF37BCF294500000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_05 = 256'h0000000000000000000000000000000029457BCF9CF3A534A534A534A534A534;
defparam prom_inst_0.INIT_RAM_06 = 256'h9CD39CF3A514A514A514A514A5149CD3630C0000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_07 = 256'h0000000000000000000000000000630C9CD3A514A514A514A514A5149CF39CD3;
defparam prom_inst_0.INIT_RAM_08 = 256'hCB6CC3AEAC309CB29CD39CF39CF39CF39CF37BEF108200000000000000000000;
defparam prom_inst_0.INIT_RAM_09 = 256'h0000000000000000000010827BEF9CF39CF39CF39CF394928C30A3AEBB6DCB4C;
defparam prom_inst_0.INIT_RAM_0A = 256'hF9A0F9C0F9E2F245DB8CACB29CD39CD39CD39CD37BEF08610000000000000000;
defparam prom_inst_0.INIT_RAM_0B = 256'h000000000000000008617BEF9CD39CD39CD38C718BAECAAAF1C3F980F980F9A0;
defparam prom_inst_0.INIT_RAM_0C = 256'hF9A0FA48FB2CFBEFFC30FBADCBEE9CF394B294B294B273AE0000000000000000;
defparam prom_inst_0.INIT_RAM_0D = 256'h000000000000000073AE94B294B294B27BEFBACAF982F960F960F980F980F980;
defparam prom_inst_0.INIT_RAM_0E = 256'hF9A3FA49FB0CFBCFFC71FD34FD13E3ADA4F39492949294925ACB000000000000;
defparam prom_inst_0.INIT_RAM_0F = 256'h0000000000005ACB9492949294927BAEDA27F940F940F940F960F960F980F980;
defparam prom_inst_0.INIT_RAM_10 = 256'hF983FA08FACBFB8EFC51FD14FDD6FDD7E3AD9CF38C718C718C51210400000000;
defparam prom_inst_0.INIT_RAM_11 = 256'h0000000021048C518C718C7173AEDA07F920F920F940F940F940F960F960F980;
defparam prom_inst_0.INIT_RAM_12 = 256'hF962F9E7FAAAFB6DFC10FCD3FD96FE59FDF7D40F94B28C518C51632C00000000;
defparam prom_inst_0.INIT_RAM_13 = 256'h00000000632C8C518C517BEFBA48F900F900F920F920F940F940F940F960F960;
defparam prom_inst_0.INIT_RAM_14 = 256'hF960F9A6FA69FB2CFBEFFCB2FD75FE18FEDBFC90B4F38C518430841010A20000;
defparam prom_inst_0.INIT_RAM_15 = 256'h000010A28410843084307AEBF901F8E0F900F900F920F920F940F940F940F960;
defparam prom_inst_0.INIT_RAM_16 = 256'hF960F984FA49FB0CFBAEFC71FD34FDF7FEBAFE58DBCE9492841084104A490000;
defparam prom_inst_0.INIT_RAM_17 = 256'h00004A498410841073AECA07F8E0F8E0F8E0F900F900F920F920F940F940F940;
defparam prom_inst_0.INIT_RAM_18 = 256'hF940F960F9E6FACBFB8EFC51FD13FDB6FE79FEFBF245A4F37BEF7BEF630C0000;
defparam prom_inst_0.INIT_RAM_19 = 256'h0000630C7BEF7BEF6B2CF102F8C0F8E0F8E0F8E0F900F900F920F920F940F940;
defparam prom_inst_0.INIT_RAM_1A = 256'hF940F940F960FA48FB4DFC10FCD3FD96FE59FEBAF9C0BCB27BEF7BCF6B6D0000;
defparam prom_inst_0.INIT_RAM_1B = 256'h00006B6D7BCF7BCF8A8AF8A0F8C0F8C0F8E0F8E0F8E0F900F900F920F920F940;
defparam prom_inst_0.INIT_RAM_1C = 256'hF940F940F940F960FA47FBCEFCB2FD55FE18FD13F9C0CC50841073AE738E0000;
defparam prom_inst_0.INIT_RAM_1D = 256'h0000738E73AE73AEAA08F8A0F8A0F8C0F8C0F8E0F8E0F8E0F900F900F920F920;
defparam prom_inst_0.INIT_RAM_1E = 256'hF920F940F940F940F960F981FAA9FB8DFB4BF9A0F9A0D3EF8410738E738E0000;
defparam prom_inst_0.INIT_RAM_1F = 256'h0000738E738E6B6DB9E7F8A0F8A0F8A0F8C0F8C0F8E0F8E0F8E0F900F900F920;
defparam prom_inst_0.INIT_RAM_20 = 256'hF920F920F940F940F940F960F960F980F980F980F9A0D3EF84106B6D6B6D0000;
defparam prom_inst_0.INIT_RAM_21 = 256'h00006B6D6B6D6B4DB9E7F880F8A0F8A0F8A0F8C0F8C0F8E0F8E0F8E0F900F900;
defparam prom_inst_0.INIT_RAM_22 = 256'hF900F920F920F940F940F940F960F960F980F980F980CC307BCF6B4D632C0000;
defparam prom_inst_0.INIT_RAM_23 = 256'h0000632C6B4D6B4DA9E7F880F880F8A0F8A0F8A0F8C0F8C0F8E0F8E0F8E0F900;
defparam prom_inst_0.INIT_RAM_24 = 256'hF900F900F920F920F940F940F940F960F960F980F980B4916B4D632C5AEB0000;
defparam prom_inst_0.INIT_RAM_25 = 256'h00005AEB632C632C8A49F880F880F880F8A0F8A0F8A0F8C0F8C0F8E0F8E0F8E0;
defparam prom_inst_0.INIT_RAM_26 = 256'hF8E0F900F900F920F920F940F940F940F960F960F2059492632C632C4A690000;
defparam prom_inst_0.INIT_RAM_27 = 256'h00004A69632C632C5AAAF0C2F880F880F880F8A0F8A0F8A0F8C0F8C0F8E0F8E0;
defparam prom_inst_0.INIT_RAM_28 = 256'hF8E0F8E0F900F900F920F920F940F940F940F960DB6D7BEF630C630C31A60000;
defparam prom_inst_0.INIT_RAM_29 = 256'h000031A6630C630C5ACBC1A6F860F880F880F880F8A0F8A0F8A0F8C0F8C0F8E0;
defparam prom_inst_0.INIT_RAM_2A = 256'hF8E0F8E0F8E0F900F900F920F920F940F940F9A3A471630C5AEB5ACB08410000;
defparam prom_inst_0.INIT_RAM_2B = 256'h000008415ACB5AEB5ACB7269F881F860F880F880F880F8A0F8A0F8A0F8C0F8C0;
defparam prom_inst_0.INIT_RAM_2C = 256'hF8C0F8E0F8E0F8E0F900F900F920F920F940CB8D73AE5ACB5ACB39E700000000;
defparam prom_inst_0.INIT_RAM_2D = 256'h0000000039E75ACB5ACB52AAB1E7F860F860F880F880F880F8A0F8A0F8A0F8C0;
defparam prom_inst_0.INIT_RAM_2E = 256'hF8C0F8C0F8E0F8E0F8E0F900F900F920E2CA841052AA52AA528A108200000000;
defparam prom_inst_0.INIT_RAM_2F = 256'h000000001082528A52AA52AA528AD165F860F860F880F880F880F8A0F8A0F8A0;
defparam prom_inst_0.INIT_RAM_30 = 256'hF8A0F8C0F8C0F8E0F8E0F8E0F900E2A98C1052AA528A528A2965000000000000;
defparam prom_inst_0.INIT_RAM_31 = 256'h0000000000002965528A528A528A5A8AD185F860F860F880F880F880F8A0F8A0;
defparam prom_inst_0.INIT_RAM_32 = 256'hF8A0F8A0F8C0F8C0F8E0F922C32C7BCF528A4A694A6939E70000000000000000;
defparam prom_inst_0.INIT_RAM_33 = 256'h000000000000000039E74A694A694A69528ABA07F8A1F860F880F880F880F8A0;
defparam prom_inst_0.INIT_RAM_34 = 256'hF8A0F8A0F8A0F143D2AA93AE632C4A494A494A4939E700200000000000000000;
defparam prom_inst_0.INIT_RAM_35 = 256'h0000000000000000002039E74A494A494A494A69728AC9E7F0E2F880F880F880;
defparam prom_inst_0.INIT_RAM_36 = 256'hC28AB2CB9B2C6B6D5AEB4A4942284228422831A6000000000000000000000000;
defparam prom_inst_0.INIT_RAM_37 = 256'h00000000000000000000000031A642284228422842284A695ACB92CAB28ABA69;
defparam prom_inst_0.INIT_RAM_38 = 256'h4A694A494208420842084208420839E721240000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_39 = 256'h0000000000000000000000000000212439E74208420842084208420842284A69;
defparam prom_inst_0.INIT_RAM_3A = 256'h39E739E739E739E739E739E72965084100000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_3B = 256'h000000000000000000000000000000000841296539E739E739E739E739E739E7;
defparam prom_inst_0.INIT_RAM_3C = 256'h39C731A63186296518E300200000000000000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_3D = 256'h0000000000000000000000000000000000000000002018E32965318631A639C7;
defparam prom_inst_0.INIT_RAM_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
defparam prom_inst_0.INIT_RAM_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

endmodule //rom_led_on
