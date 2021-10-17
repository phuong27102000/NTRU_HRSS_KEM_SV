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
