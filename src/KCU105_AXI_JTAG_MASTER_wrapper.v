//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2_AR67511 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
//Date        : Sat Aug 13 13:12:08 2016
//Host        : centosMC running 64-bit CentOS release 6.8 (Final)
//Command     : generate_target KCU105_AXI_JTAG_MASTER_wrapper.bd
//Design      : KCU105_AXI_JTAG_MASTER_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module KCU105_AXI_JTAG_MASTER_wrapper
   (reset,
    sysclk_125_clk_n,
    sysclk_125_clk_p);
  input reset;
  input sysclk_125_clk_n;
  input sysclk_125_clk_p;

  wire reset;
  wire sysclk_125_clk_n;
  wire sysclk_125_clk_p;

  KCU105_AXI_JTAG_MASTER KCU105_AXI_JTAG_MASTER_i
       (.reset(reset),
        .sysclk_125_clk_n(sysclk_125_clk_n),
        .sysclk_125_clk_p(sysclk_125_clk_p));
endmodule
