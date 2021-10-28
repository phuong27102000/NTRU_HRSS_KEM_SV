`include "ControlUnit.sv"
`include "inc.sv"

`include "ternary.sv"
`include "mod3_i8_o2.sv"

`include "pack_s3.sv"
`include "trit5_to_bit8.sv"
`include "ppa_sk.sv"
`include "mux.sv"

`include "sha3_256.sv"
`include "unpack_rq0.sv"

`timescale 1ns / 1ps

module encapsulate;
	parameter RANDOM_BITS = 16, HASH_BITS = 1088, SHA3_256_BITS = 1600;
	parameter R_BITS = 1400, TER_BITS = 20, PUBLIC_KEY_BITS = 9113;
	wire ovr_rst1, clk;
	wire [25:0] h;
	wire [RANDOM_BITS:1] bits;
//------------------------------------------------------------------------------
//  UNPACK_RQ0
	wire ovr_rst2, sipo_u_clk, up_rq0_done;
	wire [PUBLIC_KEY_BITS:1] h_mem;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  TERNARY
	wire sipo_t1_clk, sipo_t2_clk, sipo_t2_done;
	wire [R_BITS+TER_BITS : 1] rm;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  PACK_S3
	wire p3_rst, sipo_p_clk, sipo_p_stop;
	wire [1:0] p3_count;
	wire [HASH_BITS:1] prm;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// SHA3_256
	wire hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk;
	wire hash_fin;
	wire [SHA3_256_BITS:1] s_next;
	reg  [256:1] k;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  POLY_MUL_IN_RQ
	wire [1:0] poly_r;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  LIFT
	wire [3:0] poly_m;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  Structural Design Area
	Control_Unit CU (ovr_rst1, ovr_rst2, clk, halt_n, sipo_u_clk, sipo_t1_clk,
	sipo_t2_clk, sipo_t2_done, sipo_p_clk, sipo_p_stop, p3_rst, p3_count,
	hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin,
	enc_rst, up_rq0_done);

	unpack_rq0 UP_RQ0 ( .rst( ovr_rst1 ), .clk( sipo_u_clk ), .even( h[12:0] ),
	.odd( h[25:13] ), .h_mem( h_mem ), .odd_done( sipo_t2_done ),
	.even_done( up_rq0_done ) );

	ternary TER ( .rst( ovr_rst1 ), .clk1( sipo_t1_clk ), .clk2( sipo_t2_clk ),
	.bits( bits ), .rm( rm ) );

	pack_s3 PS3 ( .ovr_rst( ovr_rst2 ), .rst( p3_rst ), .clk1( sipo_t1_clk ),
	.clk2( sipo_p_clk ), .stop( sipo_p_stop ), .count( p3_count ),
	.rm( rm[R_BITS+TER_BITS : R_BITS+1] ), .prm( prm ) );

	sha3_256 HASH ( .ovr_rst( ovr_rst1 ), .rst1( hash_rst1 ), .rst2( hash_rst2 ),
	.sample( hash_sp ), .answer( hash_ans ), .keccak_sp( hash_keccak ),
	.keccak_clk( hash_clk ), .finish( hash_fin ), .prm( prm ), .out( s_next ) );

	assign #0.2 poly_r = sipo_t2_clk ? rm[2:1] : rm[4:3];
	assign poly_m = rm[R_BITS+TER_BITS : R_BITS+TER_BITS-3];
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Behavioral Design Area
	always @ ( posedge clk ) begin
		if (halt_n) begin
			k <= 0;
		end else begin
			k <= s_next;
		end
	end
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Generate waveform
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end
//------------------------------------------------------------------------------
endmodule
