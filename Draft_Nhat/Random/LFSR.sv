module LFSR (
	input wire clk,
	input wire rst,
	output reg [256:1] coins
	);
	integer i;
	wire feedback_256= coins[256];
	wire feedback_32= coins[32];
	wire feedback_22= coins[22];	
	wire feedback_2= coins[2];
	always @(posedge clk) begin
		if (rst==1)
			coins<=256'd65536;
		else begin
			coins[1]<=feedback_256^feedback_32^feedback_22^feedback_2;
			coins[256:2]<=coins[256:1];
		end
	end
endmodule
