module PE(
		input 	RST,
		input 	CLK,
		input 	WE,
		input 	[17:0]SUMIN,
		output 	[17:0]SUMO,
		input 	[17:0]DIN,
		output 	[17:0]DO
	);
	
	reg [17:0]	step_register = 0;
	reg [17:0] 	sum_register = 0;
	reg [17:0]	parameter_register = 0;
	
	reg [35:0] mul;
	
	assign SUMO = sum_register;
	assign DO = step_register;

	always@(posedge CLK)
	begin
		if(~RST)
			begin
				step_register <= 0;
				sum_register <= 0;
				parameter_register <= 0;
			end
		else if(WE)
			begin
				parameter_register <= step_register;
			end
		else
			begin
				mul <= ($signed(step_register) * $signed(parameter_register));
				sum_register <= (mul >> 9) + SUMIN;
				step_register <= DIN;
			end
	end
endmodule
