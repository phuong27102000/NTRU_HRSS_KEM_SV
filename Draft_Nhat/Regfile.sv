module Regfile (in1, clk, out);
	input wire [31:0] in1;
	input wire clk;
	output reg [31:0] out;
	always @(negedge clk) begin
		out<=in1;
	end
endmodule
