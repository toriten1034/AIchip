// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Yue Yang          :| 08/25/2014:| Initial Revision
// ============================================================================
`define Enable_CLOCK2
`define Enable_CLOCK3
`define Enable_CLOCK4
`define Enable_CLOCK
`define Enable_DRAM
`define Enable_GPIO
`define Enable_HEX0
`define Enable_HEX1
`define Enable_HEX2
`define Enable_HEX3
`define Enable_HEX4
`define Enable_HEX5
`define Enable_KEY
`define Enable_LEDR
`define Enable_PS2
`define Enable_RESET
`define Enable_SD
`define Enable_SW
`define Enable_VGA

module DE0_CV_golden_top (

`ifdef Enable_CLOCK2
      ///////// CLOCK2 "3.3-V LVTTL" /////////
      input              CLOCK2_50,
`endif	  

`ifdef Enable_CLOCK3
      ///////// CLOCK3 "3.3-V LVTTL" /////////
      input              CLOCK3_50,
`endif

`ifdef Enable_CLOCK4
      ///////// CLOCK4  "3.3-V LVTTL"  /////////
      inout              CLOCK4_50,
`endif	  
`ifdef Enable_CLOCK
      ///////// CLOCK  "3.3-V LVTTL" /////////
      input              CLOCK_50,
`endif
`ifdef Enable_DRAM
      ///////// DRAM  "3.3-V LVTTL" /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
`endif
`ifdef Enable_GPIO
      ///////// GPIO "3.3-V LVTTL" /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,
`endif
`ifdef Enable_HEX0
      ///////// HEX0  "3.3-V LVTTL" /////////
      output      [6:0]  HEX0,
`endif
`ifdef Enable_HEX1
      ///////// HEX1 "3.3-V LVTTL" /////////
      output      [6:0]  HEX1,
`endif
`ifdef Enable_HEX2
      ///////// HEX2 "3.3-V LVTTL" /////////
      output      [6:0]  HEX2,
`endif
`ifdef Enable_HEX3
      ///////// HEX3 "3.3-V LVTTL" /////////
      output      [6:0]  HEX3,
`endif
`ifdef Enable_HEX4
      ///////// HEX4 "3.3-V LVTTL" /////////
      output      [6:0]  HEX4,
`endif
`ifdef Enable_HEX5
      ///////// HEX5 "3.3-V LVTTL" /////////
      output      [6:0]  HEX5,
`endif
`ifdef Enable_KEY
      ///////// KEY  "3.3-V LVTTL" /////////
      input       [3:0]  KEY,
`endif
`ifdef Enable_LEDR
      ///////// LEDR /////////
      output      [9:0]  LEDR,
`endif
`ifdef Enable_PS2
      ///////// PS2 "3.3-V LVTTL" /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,
`endif
`ifdef Enable_RESET
      ///////// RESET "3.3-V LVTTL" /////////
      input              RESET_N,
`endif
`ifdef Enable_SD
      ///////// SD "3.3-V LVTTL" /////////
      output             SD_CLK,
      inout              SD_CMD,
      inout       [3:0]  SD_DATA,
`endif
`ifdef Enable_SW
      ///////// SW "3.3-V LVTTL"/////////
      input       [9:0]  SW,
`endif
`ifdef Enable_VGA
      ///////// VGA  "3.3-V LVTTL" /////////
      output      [3:0]  VGA_B,
      output      [3:0]  VGA_G,
      output             VGA_HS,
      output      [3:0]  VGA_R,
      output             VGA_VS
`endif	 
);

	
	wire WE; 			//write PE internal parameter register.
	wire SystemCLK; 	//Clock of Systolic array.
	wire ShortCut; 	//Systolic array shortcut

	//SystolicArray input
	wire [17:0]SystolicArray_in_delay_in[7:0];
	wire [17:0]SystolicArray_in_delay_out[7:0];
	wire [17:0]SystolicArray_in[7:0];

	//SystolicArray input
	wire [17:0]SystolicArray_out_delay_in[7:0];
	wire [17:0]SystolicArray_out_delay_out[7:0];
	
	//signals
	wire RST;
	assign RST = GPIO_1[19];
	
	wire CLK;
	assign CLK = GPIO_1[18];
	
	wire [17:0]DataBus;
	assign DataBus = GPIO_1[17:0];
	
	controller MainController (
		.RST(RST),
		.CLK(CLK),
		.DATA_BUS(GPIO_1[17:0]),
		.CLK_O(SystemCLK),
		//input
		.O_L0(SystolicArray_in_delay_in[0]),
		.O_L1(SystolicArray_in_delay_in[1]),
		.O_L2(SystolicArray_in_delay_in[2]),
		.O_L3(SystolicArray_in_delay_in[3]),
		.O_L4(SystolicArray_in_delay_in[4]),
		.O_L5(SystolicArray_in_delay_in[5]),
		.O_L6(SystolicArray_in_delay_in[6]),
		.O_L7(SystolicArray_in_delay_in[7]),
		//output
		.IN_L0(SystolicArray_out_delay_out[0]),
		.IN_L1(SystolicArray_out_delay_out[1]),
		.IN_L2(SystolicArray_out_delay_out[2]),
		.IN_L3(SystolicArray_out_delay_out[3]),
		.IN_L4(SystolicArray_out_delay_out[4]),
		.IN_L5(SystolicArray_out_delay_out[5]),
		.IN_L6(SystolicArray_out_delay_out[6]),
		.IN_L7(SystolicArray_out_delay_out[7]),
		.SHORT_CUT(ShortCut),
		.WE(WE)
	);
	
	
	delay Delay_input (
		.CLK(SystemCLK),
		//input
		.IN_L0(SystolicArray_in_delay_in[7]),
		.IN_L1(SystolicArray_in_delay_in[6]),
		.IN_L2(SystolicArray_in_delay_in[5]),
		.IN_L3(SystolicArray_in_delay_in[4]),
		.IN_L4(SystolicArray_in_delay_in[3]),
		.IN_L5(SystolicArray_in_delay_in[2]),
		.IN_L6(SystolicArray_in_delay_in[1]),
		.IN_L7(SystolicArray_in_delay_in[0]),
		//output
		.O_L0(SystolicArray_in_delay_out[7]),
		.O_L1(SystolicArray_in_delay_out[6]),
		.O_L2(SystolicArray_in_delay_out[5]),
		.O_L3(SystolicArray_in_delay_out[4]),
		.O_L4(SystolicArray_in_delay_out[3]),
		.O_L5(SystolicArray_in_delay_out[2]),
		.O_L6(SystolicArray_in_delay_out[1]),
		.O_L7(SystolicArray_in_delay_out[0])
	);

	assign SystolicArray_in[7] = (ShortCut? SystolicArray_in_delay_in[7]:SystolicArray_in_delay_out[7]);
	assign SystolicArray_in[6] = (ShortCut? SystolicArray_in_delay_in[6]:SystolicArray_in_delay_out[6]);
	assign SystolicArray_in[5] = (ShortCut? SystolicArray_in_delay_in[5]:SystolicArray_in_delay_out[5]);
	assign SystolicArray_in[4] = (ShortCut? SystolicArray_in_delay_in[4]:SystolicArray_in_delay_out[4]);
	assign SystolicArray_in[3] = (ShortCut? SystolicArray_in_delay_in[3]:SystolicArray_in_delay_out[3]);
	assign SystolicArray_in[2] = (ShortCut? SystolicArray_in_delay_in[2]:SystolicArray_in_delay_out[2]);
	assign SystolicArray_in[1] = (ShortCut? SystolicArray_in_delay_in[1]:SystolicArray_in_delay_out[1]);
	assign SystolicArray_in[0] = (ShortCut? SystolicArray_in_delay_in[0]:SystolicArray_in_delay_out[0]);

	
	delay Delay_output (
		.CLK(SystemCLK),
		//input
		.IN_L0(SystolicArray_out_delay_in[0]),
		.IN_L1(SystolicArray_out_delay_in[1]),
		.IN_L2(SystolicArray_out_delay_in[2]),
		.IN_L3(SystolicArray_out_delay_in[3]),
		.IN_L4(SystolicArray_out_delay_in[4]),
		.IN_L5(SystolicArray_out_delay_in[5]),
		.IN_L6(SystolicArray_out_delay_in[6]),
		.IN_L7(SystolicArray_out_delay_in[7]),
		//outoput
		.O_L0(SystolicArray_out_delay_out[0]),
		.O_L1(SystolicArray_out_delay_out[1]),
		.O_L2(SystolicArray_out_delay_out[2]),
		.O_L3(SystolicArray_out_delay_out[3]),
		.O_L4(SystolicArray_out_delay_out[4]),
		.O_L5(SystolicArray_out_delay_out[5]),
		.O_L6(SystolicArray_out_delay_out[6]),
		.O_L7(SystolicArray_out_delay_out[7])
	);
	
	SystolicArray systolic (
	// port map - connection between master ports and signals/registers   
		.CLK(SystemCLK),
		.IN_0(SystolicArray_in[0]),
		.IN_1(SystolicArray_in[1]),
		.IN_2(SystolicArray_in[2]),
		.IN_3(SystolicArray_in[3]),
		.IN_4(SystolicArray_in[4]),
		.IN_5(SystolicArray_in[5]),
		.IN_6(SystolicArray_in[6]),
		.IN_7(SystolicArray_in[7]),
		.OUT_A(SystolicArray_out_delay_in[0]),
		.OUT_B(SystolicArray_out_delay_in[1]),
		.OUT_C(SystolicArray_out_delay_in[2]),
		.OUT_D(SystolicArray_out_delay_in[3]),
		.OUT_E(SystolicArray_out_delay_in[4]),
		.OUT_F(SystolicArray_out_delay_in[5]),
		.OUT_G(SystolicArray_out_delay_in[6]),
		.OUT_H(SystolicArray_out_delay_in[7]),
		.RST(RST),
		.WE(WE)
	);

endmodule 

