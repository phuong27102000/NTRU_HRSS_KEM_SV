module Regfile (in1, clk, out,rst);
	parameter NUM_WIDTH_LENGTH=13;
	input wire [NUM_WIDTH_LENGTH-1:0] in1;
	input wire clk;
	input logic rst;
	output reg [NUM_WIDTH_LENGTH-1:0] out;
	always @(negedge clk) begin
	if (rst==0)
		out<=in1;
	else
		out<=0;
	end
endmodule
