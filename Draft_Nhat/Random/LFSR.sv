module LFSR (
	input logic clk,
	input logic rst,
	output logic [256:1] coins
	);
	integer i;
	wire feedback_256= coins[256];
	wire feedback_32= coins[32];
	wire feedback_22= coins[22];	
	wire feedback_2= coins[2];
	always @(posedge clk) begin
		if (rst==1)
			coins<=256'd115792089237316195423570985008687907853269984665640564039457584;
		else begin
			coins[1]<=feedback_256^feedback_32^feedback_22^feedback_2;
			for (i=1; i<=255; i=i+1) begin
				coins[i+1]<=coins[i];
			end
		end
	end
endmodule
