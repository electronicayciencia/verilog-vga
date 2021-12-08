//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8
//Part Number: GW1N-LV1QN48C6/I5
//Device: GW1N-1
//Created Time: Fri Dec 03 14:30:21 2021

module rom_mono (dout, clk, oce, ce, reset, ad);

output [0:0] dout;
input clk;
input oce;
input ce;
input reset;
input [15:0] ad;

wire lut_f_0;
wire lut_f_1;
wire lut_f_2;
wire lut_f_3;
wire [30:0] prom_inst_0_dout_w;
wire [0:0] prom_inst_0_dout;
wire [30:0] prom_inst_1_dout_w;
wire [0:0] prom_inst_1_dout;
wire [30:0] prom_inst_2_dout_w;
wire [0:0] prom_inst_2_dout;
wire [30:0] prom_inst_3_dout_w;
wire [0:0] prom_inst_3_dout;
wire dff_q_0;
wire dff_q_1;
wire mux_o_0;
wire mux_o_1;

LUT3 lut_inst_0 (
  .F(lut_f_0),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_0.INIT = 8'h02;
LUT3 lut_inst_1 (
  .F(lut_f_1),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_1.INIT = 8'h08;
LUT3 lut_inst_2 (
  .F(lut_f_2),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_2.INIT = 8'h20;
LUT3 lut_inst_3 (
  .F(lut_f_3),
  .I0(ce),
  .I1(ad[14]),
  .I2(ad[15])
);
defparam lut_inst_3.INIT = 8'h80;
pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[30:0],prom_inst_0_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_0),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 1;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'h0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
defparam prom_inst_0.INIT_RAM_01 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_02 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_03 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_04 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_05 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_06 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_07 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_08 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_09 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0A = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_0F = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_10 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_11 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_12 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_13 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_14 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_15 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_16 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_17 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_18 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_19 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_1A = 256'h000080000000000000000000000000000003C000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_1B = 256'h000080000000000000000000000000000003C00FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_1C = 256'h000080000000000000000000000000000003C03FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_1D = 256'h000080000000000000000000000000000003C07FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_1E = 256'h000080000000000000000000000000000003C07C0E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_1F = 256'h000080000000000000000000000000000003C0780E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_20 = 256'h000080000000000000000000000000000003C0700E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_21 = 256'h00008000000000000000000003BF8003F803C0700E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_22 = 256'h00008000000000000000000003FFC00FFC03C0780E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_23 = 256'h00008000000000000000000003FFE01FFE03C03C0E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_24 = 256'h00008000000000000000000003E1F01F1F03C01FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_25 = 256'h00008000000000000000000003C0F03C0F03C07FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_26 = 256'h00008000000000000000000003C070380703C0FFFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_27 = 256'h00008000000000000000000003C078380783C0F80E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_28 = 256'h00008000000000000000000003C078380783C1E00E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_29 = 256'h00008000000000000000000003C078380783C1E00E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2A = 256'h00008000000000000000000003C078380783C1C00E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2B = 256'h00008000000000000000000003C078380703C1E00E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2C = 256'h00008000000000000000000003C0703C0F03C1E00E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2D = 256'h00008000000000000000000003F1F01F1F03C0F80E0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2E = 256'h00008000000000000000000003FFE01FFE03C0FFFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_2F = 256'h00008000000000000000000003FFE00FFC03C07FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_30 = 256'h00008000000000000000000003DF8003F803C01FFE0000000000000000000001;
defparam prom_inst_0.INIT_RAM_31 = 256'h00008000000000000000000003C0000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_32 = 256'h00008000000000000000000001C0000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_33 = 256'h00008000000000000000000001F0000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_34 = 256'h00008000000000000000000000FFE00000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_35 = 256'h00008000000000000000000000FFE00000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_36 = 256'h000080000000000000000000003FE00000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_37 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_38 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_39 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3A = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_0.INIT_RAM_3F = 256'h0000800000000000000000000000000000000000000000000000000000000001;

pROM prom_inst_1 (
    .DO({prom_inst_1_dout_w[30:0],prom_inst_1_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_1),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_1.READ_MODE = 1'b0;
defparam prom_inst_1.BIT_WIDTH = 1;
defparam prom_inst_1.RESET_MODE = "SYNC";
defparam prom_inst_1.INIT_RAM_00 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_01 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_02 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_03 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_04 = 256'h000080000000000000000000000003C0000000000000000003C0000000000001;
defparam prom_inst_1.INIT_RAM_05 = 256'h000080000000000000000780000001C0000000000000000003C1FFF800000001;
defparam prom_inst_1.INIT_RAM_06 = 256'h000080000000000000000780000001E0000000F00000000003C1FFF800000001;
defparam prom_inst_1.INIT_RAM_07 = 256'h000080000000000000000780000000E0000000F00000000003C1FFF800000001;
defparam prom_inst_1.INIT_RAM_08 = 256'h00008000000000000000000000000070000000F00000000003C0003800000001;
defparam prom_inst_1.INIT_RAM_09 = 256'h00008000000000000000000000000000000000F00000000003C0003800000001;
defparam prom_inst_1.INIT_RAM_0A = 256'h00008000000000000000000000000000000000F00000000003C0003800000001;
defparam prom_inst_1.INIT_RAM_0B = 256'h0000800000000FF80FE007807F7801FC0F9E1FF83F8007F003C0003800000001;
defparam prom_inst_1.INIT_RAM_0C = 256'h0000800000003FF83FF80780FFF807FE0FFE1FF8FFE00FFC03C0003800000001;
defparam prom_inst_1.INIT_RAM_0D = 256'h0000800000003FF83FFC0780FFF80FFF0FFE1FF8FFF01FFE03C0003800000001;
defparam prom_inst_1.INIT_RAM_0E = 256'h0000800000007C003C7E0781F1F80F8F807E00F0F1F81E1F03C1FFF800000001;
defparam prom_inst_1.INIT_RAM_0F = 256'h0000800000007000001E0781E0781E07801E00F00078380703C1FFF800000001;
defparam prom_inst_1.INIT_RAM_10 = 256'h0000800000007000000E0781C0781C03801E00F00038380703C1FFF800000001;
defparam prom_inst_1.INIT_RAM_11 = 256'h0000800000007FE0000F0781C0781C03C01E00F0003C3FFF83C0003800000001;
defparam prom_inst_1.INIT_RAM_12 = 256'h0000800000007FF8000F0781C0781C03C01E00F0003C3FFF83C0003800000001;
defparam prom_inst_1.INIT_RAM_13 = 256'h0000800000007FFC000F0781C0781C03C01E00F0003C3FFF83C0003800000001;
defparam prom_inst_1.INIT_RAM_14 = 256'h00008000000070FC000F0781C0781C03C01E00F0003C000783C0003800000001;
defparam prom_inst_1.INIT_RAM_15 = 256'h000080000000701E000F0781C0781C03801E00F0003C000703C0003800000001;
defparam prom_inst_1.INIT_RAM_16 = 256'h000080000000701E001E0781C0781E07801E00F00078000F03C0003800000001;
defparam prom_inst_1.INIT_RAM_17 = 256'h0000800000007C3E3C3E0781C0780F8F801E19E0F0F83C3F03C0003800000001;
defparam prom_inst_1.INIT_RAM_18 = 256'h0000800000007FFC3FFC0781C0780FFF001E1FE0FFF03FFE03C1FFF800000001;
defparam prom_inst_1.INIT_RAM_19 = 256'h0000800000007FFC3FF80781C07807FE001E1FE0FFE03FFC03C1FFF800000001;
defparam prom_inst_1.INIT_RAM_1A = 256'h00008000000073F00FF00781C07801FC001E1FC03FC00FF003C1FFF800000001;
defparam prom_inst_1.INIT_RAM_1B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_1C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_1D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_1E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_1F = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_20 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_21 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_22 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_23 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_24 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_25 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_26 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_27 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_28 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_29 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2A = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_2F = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_30 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_31 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_32 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_33 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_34 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_35 = 256'h00008000000000000000000000000000E00E0000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_36 = 256'h00008000000000000000000000000000E01E0000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_37 = 256'h00008000000000000000000000000000F01C0000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_38 = 256'h00008000000000000000000000000000701C0000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_39 = 256'h00008000000000000000000000000000783C0000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3A = 256'h0000800000000000000000000000000038380000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3B = 256'h000080000000000000000000000000003C780000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3C = 256'h000080000000000000000000000000001C700000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3D = 256'h000080000000000000000000000000001CF00000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3E = 256'h000080000000000000000000000000001EF00000000000000000000000000001;
defparam prom_inst_1.INIT_RAM_3F = 256'h000080000000000000000000000000000EE00000000000000000000000000001;

pROM prom_inst_2 (
    .DO({prom_inst_2_dout_w[30:0],prom_inst_2_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_2),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_2.READ_MODE = 1'b0;
defparam prom_inst_2.BIT_WIDTH = 1;
defparam prom_inst_2.RESET_MODE = "SYNC";
defparam prom_inst_2.INIT_RAM_00 = 256'h000080000000000000000000000000000FE00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_01 = 256'h0000800000000000000000000000000007C00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_02 = 256'h0000800000000000000000000000000007C00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_03 = 256'h0000800000000000000000000000000003800000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_04 = 256'h0000800000000000000000000000000003800000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_05 = 256'h0000800000000000000000000000000003C00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_06 = 256'h0000800000000000000000000000000001C00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_07 = 256'h0000800000000000000000000000000001E00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_08 = 256'h0000800000000000000000000000000000E00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_09 = 256'h0000800000000000000000000000000000E00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0A = 256'h0000800000000000000000000000000000F00000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_0F = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_10 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_11 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_12 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_13 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_14 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_15 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_16 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_17 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_18 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_19 = 256'h0000800000000000000000001E000000000000000780FF800000000000000001;
defparam prom_inst_2.INIT_RAM_1A = 256'h0000800000000000000000001E000000000000000783FFE00000000000000001;
defparam prom_inst_2.INIT_RAM_1B = 256'h0000800000000000000000001E000000000000000783FFF00000000000000001;
defparam prom_inst_2.INIT_RAM_1C = 256'h00008000000000000000000000000000000000000003E1F80000000000000001;
defparam prom_inst_2.INIT_RAM_1D = 256'h00008000000000000000000000000000000000000003007C0000000000000001;
defparam prom_inst_2.INIT_RAM_1E = 256'h00008000000000000000000000000000000000000000003E0000000000000001;
defparam prom_inst_2.INIT_RAM_1F = 256'h000080000000000000001FF01E07F000FEF00FE00780001E0000000000000001;
defparam prom_inst_2.INIT_RAM_20 = 256'h000080000000000000007FF01E1FFC01FFF01FF80780000E0000000000000001;
defparam prom_inst_2.INIT_RAM_21 = 256'h000080000000000000007FF01E1FFE01FFF03FFC0780000E0000000000000001;
defparam prom_inst_2.INIT_RAM_22 = 256'h00008000000000000000F8001E1E3F03E3F03C3E0780000F0000000000000001;
defparam prom_inst_2.INIT_RAM_23 = 256'h00008000000000000000E0001E000F03C0F0700E0780000F0000000000000001;
defparam prom_inst_2.INIT_RAM_24 = 256'h00008000000000000000E0001E00070380F0700E0780000F0000000000000001;
defparam prom_inst_2.INIT_RAM_25 = 256'h00008000000000000000FFC01E00078380F07FFF0780000F0000000000000001;
defparam prom_inst_2.INIT_RAM_26 = 256'h00008000000000000000FFF01E00078380F07FFF0780000E0000000000000001;
defparam prom_inst_2.INIT_RAM_27 = 256'h00008000000000000000FFF81E00078380F07FFF0780000E0000000000000001;
defparam prom_inst_2.INIT_RAM_28 = 256'h00008000000000000000E1F81E00078380F0000F0780001E0000000000000001;
defparam prom_inst_2.INIT_RAM_29 = 256'h00008000000000000000E03C1E00078380F0000E0780003E0000000000000001;
defparam prom_inst_2.INIT_RAM_2A = 256'h00008000000000000000E03C1E000F0380F0001E0783007C0000000000000001;
defparam prom_inst_2.INIT_RAM_2B = 256'h00008000000000000000F87C1E1E1F0380F0787E0783E1F80000000000000001;
defparam prom_inst_2.INIT_RAM_2C = 256'h00008000000000000000FFF81E1FFE0380F07FFC0783FFF80000000000000001;
defparam prom_inst_2.INIT_RAM_2D = 256'h00008000000000000000FFF81E1FFC0380F07FF80783FFE00000000000000001;
defparam prom_inst_2.INIT_RAM_2E = 256'h00008000000000000000E7E01E07F80380F01FE00780FFC00000000000000001;
defparam prom_inst_2.INIT_RAM_2F = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_30 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_31 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_32 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_33 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_34 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_35 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_36 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_37 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_38 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_39 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3A = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_2.INIT_RAM_3F = 256'h0000800000000000000000000000000000000000000000000000000000000001;

pROM prom_inst_3 (
    .DO({prom_inst_3_dout_w[30:0],prom_inst_3_dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(lut_f_3),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_3.READ_MODE = 1'b0;
defparam prom_inst_3.BIT_WIDTH = 1;
defparam prom_inst_3.RESET_MODE = "SYNC";
defparam prom_inst_3.INIT_RAM_00 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_01 = 256'h0000800000000000000004224924AAAAAAAAAAADB6DBBBDFFFFFFFFFFFFFFFFF;
defparam prom_inst_3.INIT_RAM_02 = 256'h00008000000004492AAAA89492494925555556DAADB6D6BAAAAADB77FFFFFFFF;
defparam prom_inst_3.INIT_RAM_03 = 256'h00008000008920802000892124AA92AA5555B555B56DBDEBFFFFFFFEDBFFFFFF;
defparam prom_inst_3.INIT_RAM_04 = 256'h000080000400041284AA24949292552AAAAAAADB56DB6B5EAAADADB7FFDBFFFF;
defparam prom_inst_3.INIT_RAM_05 = 256'h00008000881088001080889294949552AAAAADAADDB6DEF5FFFFFFFFBF7FDFFF;
defparam prom_inst_3.INIT_RAM_06 = 256'h0000800000042052420A51242252A92AAAAB5556AB6DB5AF556D5B6DFBFFFFFF;
defparam prom_inst_3.INIT_RAM_07 = 256'h000080040040010208508524AA924AAAAAAAB55ADAAB6DBDFFEFFFFFFFFFFFFF;
defparam prom_inst_3.INIT_RAM_08 = 256'h000080000800444822822811444AA925255555B5ADDDB6F6AABDBB6FB7F77FFF;
defparam prom_inst_3.INIT_RAM_09 = 256'h0000800040890001441482A514924AAAAAAB56AD755B6ED7FFF7F7FDFF7FFEFF;
defparam prom_inst_3.INIT_RAM_0A = 256'h0000801000001248112254484954A954AAAAB56BABB5B5BD555B5EDFBFDFFFFF;
defparam prom_inst_3.INIT_RAM_0B = 256'h00008000010820010224011292494A55555555555EB76FB7FFFFFFFBF7FFFBFF;
defparam prom_inst_3.INIT_RAM_0C = 256'h00008000880081242880AA49249292A5555555B6B2DAB56D555B5ADF7EFBBFFF;
defparam prom_inst_3.INIT_RAM_0D = 256'h00008000002104008015089249552AAAAAAB6D6AD6DBEF7BFFFBFFFFFFFFFFFF;
defparam prom_inst_3.INIT_RAM_0E = 256'h000080080008004A12A02248929255252AAAAAADADAD5AED556F6DF6FBDFFFFF;
defparam prom_inst_3.INIT_RAM_0F = 256'h0000800008802900420548929424A4AAAAAAAB5575BB77AFFFEEFFBFDFFFFFFF;
defparam prom_inst_3.INIT_RAM_10 = 256'h000080404001004908281244295549555555556DAB55AD7AAABBEDEDF77DDFFF;
defparam prom_inst_3.INIT_RAM_11 = 256'h00008000001002002282A2494292554A5556DB5B5EF77BD7FFFF7FBFFFFFFFFF;
defparam prom_inst_3.INIT_RAM_12 = 256'h000080010082281288280912552495555555556AD59AD6BEAAD5EDFFDFF7FF7F;
defparam prom_inst_3.INIT_RAM_13 = 256'h00008000090000801122A92488AAA494AAAAAAAAB577B6EAFFDFBFB6FDFFFFFF;
defparam prom_inst_3.INIT_RAM_14 = 256'h000080000012202A4488009255249555555556DB6BAADDDFD57DDAFFDFDFDFFF;
defparam prom_inst_3.INIT_RAM_15 = 256'h000080110000050000115512424954A555556D56DB6EB5B55FEBBFF7FFFFFFFF;
defparam prom_inst_3.INIT_RAM_16 = 256'h0000800022002022554488A4949292955556AAB556B5EF6FFABFFBDDBDBF7DFF;
defparam prom_inst_3.INIT_RAM_17 = 256'h00008000002480440008220925552AAA555555AB6DAEAD6D57F6B77FF7FDFFFF;
defparam prom_inst_3.INIT_RAM_18 = 256'h0000800000000500A4A289524A24A52AAAAADAB6D575BBBEFEDBFFFF7FFFFFFF;
defparam prom_inst_3.INIT_RAM_19 = 256'h00008020044120120408291248A92952A55555AAB7576B75D5DF6DB6FF7BFFFF;
defparam prom_inst_3.INIT_RAM_1A = 256'h000080012004044090A142249522A52AAAAAAAADAD7ADEDBBF7DFFFFFBFFFFFF;
defparam prom_inst_3.INIT_RAM_1B = 256'h0000800000000888020A1448914AAAAAAAAAADB56B6BB5DB75EBB6DDEFF7F7FF;
defparam prom_inst_3.INIT_RAM_1C = 256'h000080000124200128A142924A2A44A49555B556D6AD6EBDEFBFFFF7FF7FFFFF;
defparam prom_inst_3.INIT_RAM_1D = 256'h0000800200008124210A142492A49AAAAAAAAAB5ADEDDBEBAD76B6FFBFFFDFFF;
defparam prom_inst_3.INIT_RAM_1E = 256'h00008020220004008420A1492492A4955556AAD6B55B6D5F7FFBFFEDEDEFFFFF;
defparam prom_inst_3.INIT_RAM_1F = 256'h0000800000242049108A0A124924AAAAAAAAADAD6F5B6DF56AAF6B7FFFFEFFDF;
defparam prom_inst_3.INIT_RAM_20 = 256'h0000800000008900422050A4925524A955556AAAD976DBAFFFFDFFF7DFBFFFFF;
defparam prom_inst_3.INIT_RAM_21 = 256'h000080008480002A088A850925494A95555555B6ABADBB6D556FADBEFDFFFFFF;
defparam prom_inst_3.INIT_RAM_22 = 256'h0000800000091100A22028A494925552AAAAAD55B6DAD6DEFFBAFFF7BFFBFBFF;
defparam prom_inst_3.INIT_RAM_23 = 256'h0000802200000020044A8224912A92552AAAD56D6D5BBDDBD5F7EDBFFBFFDFFF;
defparam prom_inst_3.INIT_RAM_24 = 256'h0000800009122482910029492AA4AA955556AB55AAED6BB6BF5FBFF77FEFFFFF;
defparam prom_inst_3.INIT_RAM_25 = 256'h0000800000000008022AA212422524AAAAAAAD5B6DADDB76EBFAF6FFF7BFFFFF;
defparam prom_inst_3.INIT_RAM_26 = 256'h0000800020204921284009489494AAA952AAAAB556DB6DAFBEAFDFD77FFF7FFF;
defparam prom_inst_3.INIT_RAM_27 = 256'h0000800201020004210AA212955292AAAAAAB5AB6DB6DBBD75FDBDFEFEFFFFFF;
defparam prom_inst_3.INIT_RAM_28 = 256'h0000802000008890845008A4508A55255555AAB6D56DB76BDFB7F7DFF7FDFFFF;
defparam prom_inst_3.INIT_RAM_29 = 256'h00008000102401021082A9094528A4AA555556AABDAB6D7EBAF6BEDDEFDFFBBF;
defparam prom_inst_3.INIT_RAM_2A = 256'h00008000010008084214425229554AAAAAAAB56DAADEDBD5F7DFF7FFFFFFFFFF;
defparam prom_inst_3.INIT_RAM_2B = 256'h00008001000090910841149245125492AAAAAB5AB75ADB5FAEBB6EDBBEFBFFFF;
defparam prom_inst_3.INIT_RAM_2C = 256'h000080402212020021144244A8A4A5555556D56B6AEB6EF57BEFFFFFF7BFEFFF;
defparam prom_inst_3.INIT_RAM_2D = 256'h0000800000002025252114490A954AAA955556AAD6AEDBAFDB7D6DDEFFFFFFFF;
defparam prom_inst_3.INIT_RAM_2E = 256'h00008004001004800004A11251249494AAAAAAD6ADDB6D7D6FD7FF7BEFFFBFFF;
defparam prom_inst_3.INIT_RAM_2F = 256'h0000800004424014AAA80A524A55295555555AB5BAB6DDD5FD7EDBFFDEF7FFFF;
defparam prom_inst_3.INIT_RAM_30 = 256'h00008000200008800001508924A25552AAAAD5AB6B6D6B6FABDB7F76FFFEFFFF;
defparam prom_inst_3.INIT_RAM_31 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_32 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_33 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_34 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_35 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_36 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_37 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_38 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_39 = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3A = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3B = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3C = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3D = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3E = 256'h0000800000000000000000000000000000000000000000000000000000000001;
defparam prom_inst_3.INIT_RAM_3F = 256'h0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

DFFE dff_inst_0 (
  .Q(dff_q_0),
  .D(ad[15]),
  .CLK(clk),
  .CE(ce)
);
DFFE dff_inst_1 (
  .Q(dff_q_1),
  .D(ad[14]),
  .CLK(clk),
  .CE(ce)
);
MUX2 mux_inst_0 (
  .O(mux_o_0),
  .I0(prom_inst_0_dout[0]),
  .I1(prom_inst_1_dout[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_1 (
  .O(mux_o_1),
  .I0(prom_inst_2_dout[0]),
  .I1(prom_inst_3_dout[0]),
  .S0(dff_q_1)
);
MUX2 mux_inst_2 (
  .O(dout[0]),
  .I0(mux_o_0),
  .I1(mux_o_1),
  .S0(dff_q_0)
);
endmodule //rom_mono