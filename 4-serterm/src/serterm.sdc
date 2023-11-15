//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8.03 
//Created Time: 2023-11-15 17:53:24
create_clock -name clock1 -period 41.667 -waveform {0 20.834} [get_ports {XTAL_IN}]
create_generated_clock -name lcd -source [get_ports {XTAL_IN}] -master_clock clock1 -divide_by 2 [get_nets {LCD_CLK_d}]
