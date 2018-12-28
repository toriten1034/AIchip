module delay(
	input CLK,
	//input 
	input [17:0]IN_L0,
	input	[17:0]IN_L1,
	input [17:0]IN_L2,
	input [17:0]IN_L3,
	input [17:0]IN_L4,
	input [17:0]IN_L5,
	input [17:0]IN_L6,
	input [17:0]IN_L7,
	//out put
	output [17:0]O_L0,
	output [17:0]O_L1,
	output [17:0]O_L2,
	output [17:0]O_L3,
	output [17:0]O_L4,
	output [17:0]O_L5,
	output [17:0]O_L6,
	output [17:0]O_L7
);
	reg [17:0] L0[0:6];
	reg [17:0] L1[0:5];
	reg [17:0] L2[0:4];
	reg [17:0] L3[0:3];
	reg [17:0] L4[0:2];
	reg [17:0] L5[0:1];
	reg [17:0] L6;
	
	assign O_L0 = L0[6];
	always@(posedge CLK)begin
		L0[6] <= L0[5];
		L0[5] <= L0[4];
		L0[4] <= L0[3];
		L0[3] <= L0[2];
		L0[2] <= L0[1];
		L0[1] <= L0[0];
		L0[0] <= IN_L0;
	end

	assign O_L1 = L1[5];
	always@(posedge CLK)begin
		L1[5] <= L1[4];
		L1[4] <= L1[3];
		L1[3] <= L1[2];
		L1[2] <= L1[1];
		L1[1] <= L1[0];
		L1[0] <= IN_L1;
	end

	assign O_L2 = L2[4];
	always@(posedge CLK)begin
		L2[4] <= L2[3];
		L2[3] <= L2[2];
		L2[2] <= L2[1];
		L2[1] <= L2[0];
		L2[0] <= IN_L2;
	end

	assign O_L3 = L3[3];
	always@(posedge CLK)begin
		L3[3] <= L3[2];
		L3[2] <= L3[1];
		L3[1] <= L3[0];
		L3[0] <= IN_L3;
	end

	assign O_L4 = L4[2];
	always@(posedge CLK)begin
		L4[2] <= L4[1];
		L4[1] <= L4[0];
		L4[0] <= IN_L4;
	end

	assign O_L5 = L5[1];
	always@(posedge CLK)begin
		L5[1] <= L5[0];
		L5[0] <= IN_L5;
	end
	
	assign O_L6 = L6;
	always@(posedge CLK)begin
		L6 <= IN_L6;
	end

	assign O_L7 = IN_L7;

endmodule
