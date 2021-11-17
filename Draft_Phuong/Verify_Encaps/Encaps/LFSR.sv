`timescale 1ns / 1ps

module LFSR (clk, rst, coins);
	input rst, clk;
	output [16:1] coins;
	reg [8:1] coins_1, coins_2;

	assign coins = {coins_1, coins_2};

	always @(posedge clk) begin
		if (rst==1)
			coins_1 <= 8'd255;
		else begin
			#0.2 coins_1 <= {coins_1[7:1], coins_1[8]^coins_1[6]^coins_1[5]^coins_1[4]};

		end
	end

	always @(posedge clk) begin
		if (rst==1)
			coins_2 <= 8'd1;
		else begin
			#0.2 coins_2 <= {coins_2[7:1], coins_2[8]^coins_2[6]^coins_2[5]^coins_2[4]};
		end
	end

endmodule
