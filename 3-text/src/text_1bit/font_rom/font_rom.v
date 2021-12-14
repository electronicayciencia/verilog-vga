//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.8
//Part Number: GW1N-LV1QN48C6/I5
//Device: GW1N-1
//Created Time: Mon Dec 13 22:31:07 2021

module font_rom (dout, clk, oce, ce, reset, ad);

output [0:0] dout;
input clk;
input oce;
input ce;
input reset;
input [13:0] ad;

wire [30:0] prom_inst_0_dout_w;

pROM prom_inst_0 (
    .DO({prom_inst_0_dout_w[30:0],dout[0]}),
    .CLK(clk),
    .OCE(oce),
    .CE(ce),
    .RESET(reset),
    .AD(ad[13:0])
);

defparam prom_inst_0.READ_MODE = 1'b0;
defparam prom_inst_0.BIT_WIDTH = 1;
defparam prom_inst_0.RESET_MODE = "SYNC";
defparam prom_inst_0.INIT_RAM_00 = 256'h00081C3E7F7F7F367EFFE7C3FFDBFF7E7E8199BD81A5817E0000000000000000;
defparam prom_inst_0.INIT_RAM_01 = 256'h0000183C3C1800001C083E7F7F3E1C081C086B7F7F1C3E1C00081C3E7F3E1C08;
defparam prom_inst_0.INIT_RAM_02 = 256'h1E333333BEF0E0F0FFC399BDBD99C3FF003C664242663C00FFFFE7C3C3E7FFFF;
defparam prom_inst_0.INIT_RAM_03 = 256'h18DB3CE7E73CDB180367E6C6C6FEC6FE070F0E0C0CFCCCFC187E183C6666663C;
defparam prom_inst_0.INIT_RAM_04 = 256'h0066006666666666183C7E18187E3C180040707C7F7C70400001071F7F1F0701;
defparam prom_inst_0.INIT_RAM_05 = 256'hFF183C7E187E3C18007E7E7E000000003E613C66663C867C00D8D8D8DEDBDBFE;
defparam prom_inst_0.INIT_RAM_06 = 256'h00000C067F060C00000018307F30180000183C7E1818181800181818187E3C18;
defparam prom_inst_0.INIT_RAM_07 = 256'h0000183C7EFFFF000000FFFF7E3C180000002466FF66240000007F0303030000;
defparam prom_inst_0.INIT_RAM_08 = 256'h0036367F367F3636000000000024666600180018183C3C180000000000000000;
defparam prom_inst_0.INIT_RAM_09 = 256'h00000000000C1818006E333B6E1C361C0063660C1833630000183E603C067C18;
defparam prom_inst_0.INIT_RAM_0A = 256'h000018187E1818000000663CFF3C6600000C18303030180C0030180C0C0C1830;
defparam prom_inst_0.INIT_RAM_0B = 256'h000103060C1830600018180000000000000000007E0000000C18180000000000;
defparam prom_inst_0.INIT_RAM_0C = 256'h003E63603C60633E007F660C3860633E007E181818181C18001C36636B63361C;
defparam prom_inst_0.INIT_RAM_0D = 256'h000C0C0C1830637F003E63633F03061C003E63603F03037F0078307F33363C38;
defparam prom_inst_0.INIT_RAM_0E = 256'h0C181800001818000018180000181800001E30607E63633E003E63633E63633E;
defparam prom_inst_0.INIT_RAM_0F = 256'h001800181830633E00060C1830180C0600007E00007E0000006030180C183060;
defparam prom_inst_0.INIT_RAM_10 = 256'h003C66030303663C003F66663E66663F006363637F63361C001E037B7B7B633E;
defparam prom_inst_0.INIT_RAM_11 = 256'h005C66730303663C000F06161E16467F007F46161E16467F001F36666666361F;
defparam prom_inst_0.INIT_RAM_12 = 256'h006766361E366667001E333330303078003C18181818183C006363637F636363;
defparam prom_inst_0.INIT_RAM_13 = 256'h003E63636363633E006363737B6F67630063636B7F7F7763007F66460606060F;
defparam prom_inst_0.INIT_RAM_14 = 256'h003C6630180C663C006766363E66663F703E73636363633E000F06063E66663F;
defparam prom_inst_0.INIT_RAM_15 = 256'h00367F6B6B636363001C366363636363003E636363636363003C1818185A7E7E;
defparam prom_inst_0.INIT_RAM_16 = 256'h003C0C0C0C0C0C3C007F664C1831637F003C18183C666666006363361C366363;
defparam prom_inst_0.INIT_RAM_17 = 256'hFF000000000000000000000063361C08003C30303030303C00406030180C0603;
defparam prom_inst_0.INIT_RAM_18 = 256'h003E6303633E0000003B6666663E0607006E333E301E0000000000000030180C;
defparam prom_inst_0.INIT_RAM_19 = 256'h1F303E33336E0000000F06061F06663C003E037F633E0000006E3333333E3038;
defparam prom_inst_0.INIT_RAM_1A = 256'h0067361E366606073C66666060600060003C1818181C0018006766666E360607;
defparam prom_inst_0.INIT_RAM_1B = 256'h003E6363633E000000666666663B0000006B6B6B7F370000003C18181818181C;
defparam prom_inst_0.INIT_RAM_1C = 256'h003F603E037E0000000F06066E3B000078303E33336E00000F063E66663B0000;
defparam prom_inst_0.INIT_RAM_1D = 256'h00367F6B6B630000001C366363630000006E33333333000000386C0C0C3F0C0C;
defparam prom_inst_0.INIT_RAM_1E = 256'h007018180E181870007E4C18327E00003F607E63636300000063361C36630000;
defparam prom_inst_0.INIT_RAM_1F = 256'h007F6363361C08000000000000003B6E000E18187018180E0018181818181818;
defparam prom_inst_0.INIT_RAM_20 = 256'h006E333E301E413E003E037F633E1830006E3333333300331E303E630303633E;
defparam prom_inst_0.INIT_RAM_21 = 256'h1C307E03037E0000006E333E301E0C0C006E333E301E180C006E333E301E0063;
defparam prom_inst_0.INIT_RAM_22 = 256'h003C1818181C0066003E037F633E180C003E037F633E0063003E037F633E413E;
defparam prom_inst_0.INIT_RAM_23 = 256'h0063637F633E361C0063637F63361C63003C18181C00180C003C1818181C413E;
defparam prom_inst_0.INIT_RAM_24 = 256'h003E6363633E413E007333337F33367C007E1B7E187E0000007F031F037F0C18;
defparam prom_inst_0.INIT_RAM_25 = 256'h006E333333330C06006E33333300211E003E6363633E180C003E6363633E0063;
defparam prom_inst_0.INIT_RAM_26 = 256'h18187E03037E1818003E636363630063001C366363361C633F607E6363630063;
defparam prom_inst_0.INIT_RAM_27 = 256'h000E1B183C18D870E363F3635F33331F18187E187E3C6666003F66060F26361C;
defparam prom_inst_0.INIT_RAM_28 = 256'h006E333333330C18003E6363633E1830003C18181C001830006E333E301E0C18;
defparam prom_inst_0.INIT_RAM_29 = 256'h00003E001C36361C00007E007C36363C00737B6F67003B6E006666663B003B6E;
defparam prom_inst_0.INIT_RAM_2A = 256'hF03366CC7E3667C6000060607F000000000003037F000000007CC60C18180018;
defparam prom_inst_0.INIT_RAM_2B = 256'h00003366CC6633000000CC663366CC0000183C3C1818001860FB566C5E3667C6;
defparam prom_inst_0.INIT_RAM_2C = 256'h1818181818181818BBEEBBEEBBEEBBEE55AA55AA55AA55AA1144114411441144;
defparam prom_inst_0.INIT_RAM_2D = 256'h6C6C6C7F000000006C6C6C6F6C6C6C6C1818181F181F18181818181F18181818;
defparam prom_inst_0.INIT_RAM_2E = 256'h6C6C6C6F607F00006C6C6C6C6C6C6C6C6C6C6C6F606F6C6C1818181F181F0000;
defparam prom_inst_0.INIT_RAM_2F = 256'h1818181F000000000000001F181F18180000007F6C6C6C6C0000007F606F6C6C;
defparam prom_inst_0.INIT_RAM_30 = 256'h181818F818181818181818FF00000000000000FF18181818000000F818181818;
defparam prom_inst_0.INIT_RAM_31 = 256'h6C6C6CEC6C6C6C6C181818F818F81818181818FF18181818000000FF00000000;
defparam prom_inst_0.INIT_RAM_32 = 256'h6C6C6CEF00FF0000000000FF00EF6C6C6C6C6CEC0CFC0000000000FC0CEC6C6C;
defparam prom_inst_0.INIT_RAM_33 = 256'h000000FF00FF18186C6C6CEF00EF6C6C000000FF00FF00006C6C6CEC0CEC6C6C;
defparam prom_inst_0.INIT_RAM_34 = 256'h000000FC6C6C6C6C6C6C6CFF00000000181818FF00FF0000000000FF6C6C6C6C;
defparam prom_inst_0.INIT_RAM_35 = 256'h6C6C6CFF6C6C6C6C6C6C6CFC00000000181818F818F80000000000F818F81818;
defparam prom_inst_0.INIT_RAM_36 = 256'hFFFFFFFFFFFFFFFF181818F8000000000000001F18181818181818FF18FF1818;
defparam prom_inst_0.INIT_RAM_37 = 256'h00000000FFFFFFFFF0F0F0F0F0F0F0F00F0F0F0F0F0F0F0FFFFFFFFF00000000;
defparam prom_inst_0.INIT_RAM_38 = 256'h00363636367F0000000303030303637F003363331B33331E006E3B133B6E0000;
defparam prom_inst_0.INIT_RAM_39 = 256'h00181818183B6E00033E666666660000000E1B1B1B7E0000007F63060C06637F;
defparam prom_inst_0.INIT_RAM_3A = 256'h003C66667C301870007736366363361C001C36637F63361C7E183C66663C187E;
defparam prom_inst_0.INIT_RAM_3B = 256'h0063636363633E0000780C067E060C7803067EDBDB7E306000007EDBDB7E0000;
defparam prom_inst_0.INIT_RAM_3C = 256'h007E0030180C1830007E000C1830180C007E0018187E181800007F007F007F00;
defparam prom_inst_0.INIT_RAM_3D = 256'h00003B6E003B6E00000018007E0018000E1B1B18181818181818181818D8D870;
defparam prom_inst_0.INIT_RAM_3E = 256'h383C3637303030F000000000180000000000001818000000000000001C36361C;
defparam prom_inst_0.INIT_RAM_3F = 256'h000000000000000000003C3C3C3C00000000003E0C18301E0000006C6C6C6C36;

endmodule //font_rom