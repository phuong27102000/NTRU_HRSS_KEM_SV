`include "ControlUnit.sv"
`include "mod3_i8_o2.sv"
`include "trit5_to_bit8.sv"
`include "sha3_256.sv"
`timescale 1ns / 1ps

module testbench;
	parameter RANDOM_BITS = 16, HASH_BITS = 1088, SHA3_256_BITS = 1600;
	wire rst, clk;
	wire [RANDOM_BITS:1] bits;
	wire [3:0] mod3;
	wire ovr_rst, fifo1_en, fio2_en, fifo2_stop, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin;
	wire [1:0] p3_count;
	wire [19:0] rm;
	wire [15:0] bytes;
	wire [HASH_BITS:1] prm;
	wire [HASH_BITS:1] p;
	wire [SHA3_256_BITS:1] s_next;
	reg [256:1] k;

	wire [HASH_BITS:1] p_reg;
	wire [SHA3_256_BITS:1] z;
    wire[1600:1] s_wire;
    output wire [1600:1] a, b, c, d, e;
    output wire [6:0] rc;

	Control_Unit CU (ovr_rst, clk, halt_n, fifo1_en, fifo2_en, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);

	mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

	fifo1 FIFO1 ( .ovr_rst( ovr_rst ), .clk( fifo1_en ), .init( mod3[3:0] ), .out( rm[19:0] ) );

	trit5_to_bit8 P3_1 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[9:0] ), .count( p3_count ), .out( bytes[7:0] ) );
	trit5_to_bit8 P3_2 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[19:10] ), .count( p3_count ), .out( bytes[15:8] ) );

	fifo2 FIFO2 ( .ovr_rst( ovr_rst ), .clk( fifo2_en ), .stop( fifo2_stop ), .init( bytes ), .out( prm[HASH_BITS:1] ) );

	pad_p pad_p ( .prm( prm ), .hash_fin( hash_fin ), .p( p ) );

	sha3_256 HASH ( .ovr_rst( ovr_rst ), .rst1( hash_rst1 ), .rst2( hash_rst2 ), .sp( hash_sp ), .ans( hash_ans ), .sp_keccak( hash_keccak ), .clk( hash_clk ), .p( p ), .out( s_next ), .z(z), .p_reg(p_reg), .s_wire( s_wire ), .a(a), .b(b), .c(c), .d(d), .e(e), .rc(rc) );

	always @ ( posedge clk ) begin
		if (halt_n) begin
			k <= 0;
		end
		else begin
			k <= s_next;
		end
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end
endmodule

module fifo1 (ovr_rst, clk, init, out);
	input ovr_rst, clk;
	input[3:0] init;
	output reg[19:0] out;

	always @ ( posedge ovr_rst or posedge clk ) begin
		if(ovr_rst) begin
			out <= 0;
		end
		else begin
			#0.1 out <= {init, out[19:4]};
		end
	end
endmodule

module fifo2 (ovr_rst, clk, stop, init, out);
	parameter HASH_BITS = 1088;
	input ovr_rst, clk, stop;
	input[15:0] init;
	output reg[HASH_BITS:1] out;
	wire local_clk;

	assign local_clk = clk & (~stop);

	always @ ( posedge ovr_rst or posedge local_clk ) begin
		if(ovr_rst) begin
			out <= 0;
		end
		else begin
			#0.1 out <= {init, out[HASH_BITS:17]};
		end
	end
endmodule

module pad_p(prm, hash_fin, p);
	parameter HASH_BITS = 1088, REMAIN_BITS = 64, ZERO_BITS = 1020; //ZERO_BITS = HASH_BITS - REMAIN_BITS - 4
	input[HASH_BITS:1] prm;
	input hash_fin;
	output[HASH_BITS:1] p;
	reg [REMAIN_BITS:1] p_reg;

	always @ ( * ) begin
		if(hash_fin) begin
			p_reg[REMAIN_BITS:1] <= prm[ HASH_BITS : HASH_BITS - REMAIN_BITS + 1 ];
		end
		else begin
			p_reg[REMAIN_BITS:1] <= prm[REMAIN_BITS:1];
		end
	end

	assign n_fin = ~hash_fin;
	assign p[ HASH_BITS : REMAIN_BITS+3 ] = { hash_fin | prm[HASH_BITS], {ZERO_BITS{n_fin}} & prm[HASH_BITS-1 : REMAIN_BITS+4], hash_fin | prm[REMAIN_BITS+3]};
	assign p[ REMAIN_BITS+2 : REMAIN_BITS+1 ] = { hash_fin | prm[REMAIN_BITS+2], n_fin & prm[REMAIN_BITS+1] };
	assign p[ REMAIN_BITS : 1] = p_reg;
endmodule
