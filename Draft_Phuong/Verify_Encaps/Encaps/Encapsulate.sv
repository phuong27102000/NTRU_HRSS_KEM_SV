`timescale 1ns / 1ps

module encapsulate(lfsr_rst, ovr_rst1, clk, h_in, c, k);
	parameter RANDOM_BITS = 16, HASH_BITS = 1088, SHA3_256_BITS = 1600;
	parameter R_BITS = 1400, TER_BITS = 20, PUBLIC_KEY_BITS = 9113;
	parameter CIPHERTEXT_BITS = 9104;

	input lfsr_rst, ovr_rst1, clk;
	input [CIPHERTEXT_BITS:1] h_in;
	output [CIPHERTEXT_BITS:1] c;
	output [256:1] k;
//------------------------------------------------------------------------------
//  LFSR
	wire [RANDOM_BITS:1] bits;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  UNPACK_RQ0
	wire ovr_rst2, sipo_u_clk, up_rq0_done;
	wire [PUBLIC_KEY_BITS:1] h;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  TERNARY
	wire sipo_t1_clk, sipo_t2_clk;
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
	reg [256:1] k_in;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  POLY_MUL_IN_RQ
	wire [1:0] poly_r;
	wire [PUBLIC_KEY_BITS:1] v;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  LIFT
	wire [3:0] poly_m;
	wire lift_en;
	wire [PUBLIC_KEY_BITS:1] m0;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  ADD_IN_RQ
	wire [PUBLIC_KEY_BITS:1] c_before_pack;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  Structural Design Area
	Control_Unit CU (ovr_rst1, ovr_rst2, clk, halt_n, sipo_u_clk, sipo_t1_clk,
	sipo_t2_clk, up_rq0_done, sipo_p_clk, sipo_p_stop, p3_rst, p3_count,
	hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin,
	enc_rst, lift_en);

	LFSR LFSR ( .clk(clk), .rst(lfsr_rst), .coins(bits));

	unpack_rq0 UP_RQ0 ( .rst( ovr_rst1 ), .clk( sipo_u_clk ),
	.done( up_rq0_done ), .h_in( h_in ), .h( h ) );

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

	polynomialmultiplication MUL ( .clk(sipo_t1_clk), .en(enc_rst), .rin(poly_r), 
	.h(h), .e(v) );

	poly_lift LIFT ( .clk(sipo_t1_clk), .rst(enc_rst), .en(lift_en), .m_in(poly_m),
	.m0(m0) );

	Add_in_Rq ADD_IN_RQ ( .v(v), .m1(m0), .c(c_before_pack) );

	pack_Rq0 PACK_RQ0 ( .c( c_before_pack ), .cnew( c ) );

	bits_to_bytes_k B2B ( .k_in(k_in), .k(k) );
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Behavioral Design Area
	always @ ( posedge clk ) begin
		if (halt_n) begin
			k_in <= 0;
		end else begin
			k_in <= s_next[256:1];
		end
	end
//------------------------------------------------------------------------------

endmodule
