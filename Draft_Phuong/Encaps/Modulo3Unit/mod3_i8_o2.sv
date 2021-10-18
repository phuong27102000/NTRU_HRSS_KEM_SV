`include "ControlUnit.sv"

module testbench;
	parameter RANDOM_BITS = 16, HASH_BITS = 1088;
	wire rst, clk;
	wire [RANDOM_BITS:1] bits;
	wire [3:0] mod3;
	wire ovr_rst, fifo1_en, fio2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin;
	wire [1:0] p3_count;
	wire [19:0] rm;

	mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

	fifo1 FIFO1 ( .clk( fifo1_en ), .rst( fifo1_rst ), .init( mod3[3:0] ), .out( rm[19:0] ) );

	Control_Unit CU (ovr_rst, clk, fifo1_en, fifo2_en, fifo1_rst, fifo2_rst, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

endmodule

module fifo1 (clk, rst, init, out);
	input rst, clk;
	input[3:0] init;
	output reg[19:0] out;

	always @ ( posedge clk ) begin
		out <= {init, out[19:4]};
	end

endmodule

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

	assign out[0] = ( in[2] ^ in[0] ) | ( in[3] & in[1] ) | ( in[2] & ( ~(in[3] | in[1]) ) );
	assign out[1] = ( in[3] ^ in[0] ) & ( in[2] ^ in[1] ) & ( ~(in[3] & in[1]) );

endmodule
