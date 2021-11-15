module mux2to1 (in1, in2, sel, out);
	input wire in1,in2,sel;
	output wire out;
	assign out=in1&~sel|in2&sel;
endmodule

module mux4 (in1, in2, sel, out);
	input wire [3:0]in1,in2;
	input wire  sel;
	output wire [3:0] out;
	mux2to1 entity_0 (.in1(in1[0]), .in2(in2[0]), .sel(sel), .out(out[0]));
	mux2to1 entity_1 (.in1(in1[1]), .in2(in2[1]), .sel(sel), .out(out[1]));
	mux2to1 entity_2 (.in1(in1[2]), .in2(in2[2]), .sel(sel), .out(out[2]));
	mux2to1 entity_3 (.in1(in1[3]), .in2(in2[3]), .sel(sel), .out(out[3]));
endmodule

module mux_N (in1, in2, sel, out);
	parameter NUM_WIDTH_LENGTH=13;
	input wire [NUM_WIDTH_LENGTH-1:0] in1, in2;
	input wire sel;
	output wire [NUM_WIDTH_LENGTH-1:0] out;
	assign out=in1&{NUM_WIDTH_LENGTH{~sel}}|in2&{NUM_WIDTH_LENGTH{sel}};
endmodule

module Xor_N_bit ( h, r, out_xor);
	parameter NUM_WIDTH_LENGTH=13;
	input wire[NUM_WIDTH_LENGTH-1:0] h;
	input wire r;
	output wire [NUM_WIDTH_LENGTH-1:0] out_xor;
	assign out_xor=h^{NUM_WIDTH_LENGTH{r}};
endmodule

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


module adder (in1, in2, cin, out, cout);
	input wire in1, in2, cin;
	output reg out, cout;
	always@* begin
		 out=in1^in2^cin;
		 cout=in1&in2|in1&cin|in2&cin;
	end
endmodule

module adder4bit (in1, in2, cin, out, cout);
	input wire [3:0] in1, in2;
	input wire cin;
	output wire [3:0] out;
	output wire cout;
	wire cout_1,cout_2,cout_3;
	adder adder_1 (.in1(in1[0]), .in2(in2[0]), .cin(cin), .out(out[0]), .cout(cout_1));
	adder adder_2 (.in1(in1[1]), .in2(in2[1]), .cin(cout_1), .out(out[1]), .cout(cout_2));
	adder adder_3 (.in1(in1[2]), .in2(in2[2]), .cin(cout_2), .out(out[2]), .cout(cout_3));
	adder adder_4 (.in1(in1[3]), .in2(in2[3]), .cin(cout_3), .out(out[3]), .cout(cout));
endmodule