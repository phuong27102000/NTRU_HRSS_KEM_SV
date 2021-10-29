module LFSR (
	input wire clk,
	input wire rst,
	output reg [16:1] coins
	);
	integer i;
	wire feedback_16= coins[16];
	wire feedback_14= coins[14];
	wire feedback_13= coins[13];	
	wire feedback_11= coins[11];
	always @(posedge clk) begin
		if (rst==1)
			coins<=16'd65536;
		else begin
			coins[1]<=feedback_16^feedback_14^feedback_13^feedback_11;
			coins[16:2]<=coins[15:1];
		end
	end
endmodule
