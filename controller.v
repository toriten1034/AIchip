`define NOP 			18'b000000000_000000000
`define STEP 			18'b000000000_000000001
//8cycle instruction
// state 1
`define WRITE_DATA	18'b000000000_000000010
// state 2
`define READ_DATA 	18'b000000000_000000011

//64cycle instruction
// state 3
`define WRITE_PARAM 	18'b000000000_000000100

module controller(
		input RST,
		input CLK,
		
		input	[17:0]IN_L0,
		input	[17:0]IN_L1,
		input	[17:0]IN_L2,
		input	[17:0]IN_L3,
		input	[17:0]IN_L4,
		input	[17:0]IN_L5,
		input	[17:0]IN_L6,
		input	[17:0]IN_L7,
		
			//out put
		output [17:0]O_L0,
		output [17:0]O_L1,
		output [17:0]O_L2,
		output [17:0]O_L3,
		output [17:0]O_L4,
		output [17:0]O_L5,
		output [17:0]O_L6,
		output [17:0]O_L7,
	
		inout  [17:0] DATA_BUS,
		output reg CLK_O,
		output reg WE,
		output reg SHORT_CUT

	);

	
	//assign 
	reg [17:0] out_buf[7:0];
	
	assign O_L0 = out_buf[0];
	assign O_L1 = out_buf[1];
	assign O_L2 = out_buf[2];
	assign O_L3 = out_buf[3];
	assign O_L4 = out_buf[4];
	assign O_L5 = out_buf[5];
	assign O_L6 = out_buf[6];
	assign O_L7 = out_buf[7];

	
	wire [17:0] in_data[7:0];

	assign in_data[0] = IN_L0;
	assign in_data[1] = IN_L1;
	assign in_data[2] = IN_L2;
	assign in_data[3] = IN_L3;
	assign in_data[4] = IN_L4;
	assign in_data[5] = IN_L5;
	assign in_data[6] = IN_L6;
	assign in_data[7] = IN_L7;
	
	
	reg [3:0] index;
	reg [3:0] state;
	reg [6:0] cnt;
	
	//data bus buffer
	reg [17:0]bus_buf;
	assign DATA_BUS = bus_buf;
	
	reg CLK_ON;

	//inverted signal
	wire CLK_N;
	assign CLK_N = ~CLK;

	//FMS
	always@(posedge CLK or posedge CLK_N)
	begin
		//posedge
		if(CLK)begin
			if(~RST)begin
				state <= 0;
				cnt <= 0;
				index <= 0;
				CLK_O <= 1;
				bus_buf <= 18'bz;
				//reset
				WE <= 0;
				SHORT_CUT <= 0;
			end
			//status
			else if(state == 0) begin
				//weite disable
				SHORT_CUT <= 0;
				WE <= 0;
				
				
				//nop
				if(DATA_BUS == `NOP )begin
					state <= 0;
					CLK_O <= 0;
				end
				//step
				else if(DATA_BUS == `STEP)begin
					state <= 0;
					CLK_O <= 0;
				end
				//write data
				else if(DATA_BUS == `WRITE_DATA)begin
					state <= 1;
					cnt <= 7;
					index <= 0;
					bus_buf <= 18'bz;

				end
				//read
				else if(DATA_BUS == `READ_DATA)begin
					state <= 2;
					cnt <= 8;
					index <= 0;
				end
				//write param
				else if(DATA_BUS == `WRITE_PARAM)begin
					bus_buf <= 18'bz;
					SHORT_CUT <= 1;
					state <= 3;
					index <= 0;
					cnt <= 64;


				end
			end
			
			//write
			else if(state == 1)begin
				if(cnt == 0)begin
					CLK_O <= 0;
					state <= 0;
					bus_buf <= 18'bz;
				end
				out_buf[index] <= DATA_BUS;
				index <= index + 1;
				cnt <= cnt - 1;
			end
			//read
			else if(state == 2)begin
				if(cnt == 0)begin
					state <= 0;
					bus_buf <= 18'bz;
				end
				else begin
					index <= index + 1;
					bus_buf <= in_data[index];
					cnt <= cnt - 1;
				end
			end
			// write parameters
			else if(state == 3)begin
				if(cnt == 0)begin
					WE <= 1; //write enable
					state <= 0;
					bus_buf <= 18'bz;
					CLK_O <= 0;
				end
				else if(index >= 7)begin
					index <= 0;
					CLK_O <= 0;
				end 
				else begin
					index <= index + 1;
				end
				out_buf[index] <= DATA_BUS;				
				cnt <= cnt - 1;
			end
		
		end
		//negedge
		else if(CLK_N)begin
			CLK_O <= 1;
		end
		
	end
	
endmodule
