module LFSR (
	input wire clk,
	input wire rst,
	output reg [8:1] coins,
	output reg [8:1] coins_2
	);
	
	integer i;
	
	wire feedback_8_LFSR_1= coins[8];
	wire feedback_6_LFSR_1= coins[6];
	wire feedback_5_LFSR_1= coins[5];	
	wire feedback_4_LFSR_1= coins[4];
	
	wire feedback_8_LFSR_2= coins_2[8];
	wire feedback_6_LFSR_2= coins_2[6];
	wire feedback_5_LFSR_2= coins_2[5];	
	wire feedback_4_LFSR_2= coins_2[4];
	
	always @(posedge clk) begin
		if (rst==1)
			coins<=8'd255;
		else begin
			coins[1]<=feedback_8_LFSR_1^feedback_6_LFSR_1^feedback_5_LFSR_1^feedback_4_LFSR_1;
			coins[8:2]<=coins[7:1];
		end
	end
	
	always @(posedge clk) begin
		if (rst==1)
			coins_2<=8'd1;
		else begin
			coins_2[1]<=feedback_8_LFSR_2^feedback_6_LFSR_2^feedback_5_LFSR_2^feedback_4_LFSR_2;
			coins_2[8:2]<=coins_2[7:1];
		end
	end

endmodule
