module mux2to1 (in1, in2, sel, out);
	input wire in1,in2,sel;
	output out;
	assign out=in1&~sel|in2&sel;
endmodule
module mux4 (in1, in2, sel, out);
	input wire [3:0]in1,in2;
	input wire  sel;
	output [3:0] out;
	mux2to1 entity_0 (.in1(in1[0]), .in2(in2[0]), .sel(sel), .out(out[0]));
	mux2to1 entity_1 (.in1(in1[1]), .in2(in2[1]), .sel(sel), .out(out[1]));
	mux2to1 entity_2 (.in1(in1[2]), .in2(in2[2]), .sel(sel), .out(out[2]));
	mux2to1 entity_3 (.in1(in1[3]), .in2(in2[3]), .sel(sel), .out(out[3]));
endmodule
module mux_N (in1, in2, sel, out);
	input wire [31:0] in1, in2;
	input wire sel;
	output wire [31:0] out;
	assign out=in1&{32{~sel}}|in2&{32{sel}};
endmodule
