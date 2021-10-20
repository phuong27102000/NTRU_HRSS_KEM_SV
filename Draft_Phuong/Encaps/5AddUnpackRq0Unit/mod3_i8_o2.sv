module mod3_i8_o2(in, out);
	input [7:0] in;
	output [1:0] out;
    wire [3:0] node;

	stage1 MOD3_1 ( .in( in[3:0] ), .out( node[1:0] ) );
	stage1 MOD3_2 ( .in( in[7:4] ), .out( node[3:2] ) );
	stage2 MOD3_3 ( .in( node[3:0] ), .out( out[1:0] ) );

endmodule

module stage1(in, out);
	input [3:0] in;
	output [1:0] out;
    wire [4:0] node;

	assign node[0] = ~(in[3]^in[2]);
	assign node[1] = ~(in[1]^in[0]);
	assign node[2] = in[1] & (~in[0]);
	assign node[3] = in[3] & (~in[2]);
	assign node[4] = (~in[3]) & in[2] & (~in[1]) & in[0];
	assign out[0] = ( node[1] ^ node[0] ) | ( node[3] & node[2] ) | node[4];
	assign out[1] = ( node[2] & node[0] ) | ( node[3] & node[1] ) | node[4];

endmodule

module stage2(in, out);
	input [3:0] in;
	output [1:0] out;

	assign #0.1 out[0] = ( in[2] ^ in[0] ) | ( in[3] & in[1] ) | ( in[2] & ( ~(in[3] | in[1]) ) );
	assign #0.1 out[1] = ( in[3] ^ in[0] ) & ( in[2] ^ in[1] ) & ( ~(in[3] & in[1]) );

endmodule
