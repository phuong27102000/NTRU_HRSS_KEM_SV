`timescale 1ns / 1ps

module Control_Unit(ovr_rst1, ovr_rst2, ex_clk, halt_n, sipo_u_clk, sipo_t1_clk,
	sipo_t2_clk, up_rq0_done, sipo_p_clk, sipo_p_stop, p3_rst, p3_count,
	hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin,
	enc_rst, lift_en);
	parameter STOP_AT = 5;
	input ovr_rst1, ex_clk;
	output halt_n, sipo_u_clk, sipo_t1_clk, sipo_t2_clk, sipo_p_clk, sipo_p_stop;
	output p3_rst, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak;
	output hash_fin, ovr_rst2, hash_clk, enc_rst, lift_en, up_rq0_done;
	output [1:0] p3_count;

	reg [2:0] sipo_t1;
	reg sipo_t2;
	reg [6:0] sipo_p, stop;
	reg [1:0] hash;
	reg [7:0] lift;
	reg [8:0] up_rq0;
	reg ovr_rst2;
	reg halt_n;
	wire sipo_t_check, sipo_p_check, lift_check;
	wire [2:0] sipo_t1_nxt, hash_nxt;
	wire sipo_t2_nxt, sipo_t2_done;
	wire [6:0] sipo_p_nxt;
	wire [7:0] lift_nxt;
	wire [8:0] up_rq0_nxt;

	assign sipo_t1_clk = ex_clk & halt_n;
	assign sipo_t2_clk = up_rq0_done ? sipo_t2 : sipo_t1_clk;
	assign sipo_u_clk = ex_clk & halt_n;

	assign sipo_p_clk = ( ^sipo_t1[1:0] ) & ( ~sipo_t1[2] ); //sipo_t1 = 1,2
	assign #0.3 sipo_p_stop = hash[1] & stop[2] & stop[0] & ( ~|{ stop[6:3], stop[1] } ); //hash >= 2 and stop = STOP_AT

	assign #0.3 p3_rst = ~( |sipo_t1 ); //sipo_t1 = 0
	assign #0.3 p3_count = { sipo_t1[1], sipo_t1[0] }; // ( sipo_t1, p3_count ) = ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 0 )

	assign #0.5 hash_rst1 = ~( |{ sipo_p[6:1], ~sipo_p[0] } ) & (~hash[1]) & hash[0]; //sipo_p = 1 and hash = 1
	assign #0.5 hash_rst2 = ~( |{ sipo_p[6:2], ~sipo_p[1] } ); //sipo_p = 2,3
	assign #0.5 hash_sp = ~( |{ sipo_p[6:1], ~sipo_p[0] } ); //sipo_p = 1
	assign hash_ans = ~( |{ sipo_p[6], ~( &sipo_p[5:4] ), sipo_p[3], ~sipo_p[2], sipo_p[1:0] } ); //sipo_p = 52
	assign hash_keccak = sipo_p[0];
	assign hash_clk = sipo_p_clk;
	assign hash_fin = ( hash[1] & hash[0] );
	assign hash_3rd_round = hash_fin & hash_ans;

	//------------------------------------------------------------------------------
	//  Counter for UNPACK_RQ0 's clock1
	always @ ( posedge sipo_t1_clk ) begin
		if (ovr_rst1) begin
			up_rq0 <= 0;
		end else begin
			if (sipo_t2_done) begin
				up_rq0 <= 351;
			end else begin
				up_rq0 <= up_rq0_nxt;
			end
		end
	end

	assign #0.3 enc_rst = sipo_t2_done ^ up_rq0_done;
	assign #0.2 up_rq0_done = up_rq0[8] & (~up_rq0[7]) & up_rq0[6] & (~up_rq0[5]) & ( &up_rq0[4:1] );
	assign #0.2 sipo_t2_done = up_rq0[8] & (~up_rq0[7]) & up_rq0[6] & (~up_rq0[5]) & ( &up_rq0[4:0] );
	inc_i9_o9 INC_UP ( .a( up_rq0 ), .out( up_rq0_nxt ) );
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Counter for SIPO TERNARY 's clock1, reset when sipo_t1 == 4
	always @ ( posedge sipo_t1_clk ) begin
		if (ovr_rst1 | sipo_t_check) begin
			sipo_t1 <= 0;
		end else begin
			sipo_t1 <= sipo_t1_nxt;
		end
	end

	assign #0.2 sipo_t_check = sipo_t1[2];
	inc_i2_i3 INC_SIPO_T1 ( .x( sipo_t1[1:0] ), .out( sipo_t1_nxt ) );
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Overall reset 2 to make sure that SIPO PACKS3 works properly
	always @ ( posedge sipo_p_clk or posedge ovr_rst1 ) begin
		if (ovr_rst1) begin
			#0.2 ovr_rst2 <= 1;
		end else begin
			#0.2 ovr_rst2 <= 0;
		end
	end
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Counter for SIPO PACK_S3, reset when sipo_p == 67
	always @ ( posedge sipo_p_clk ) begin
		if (ovr_rst2 | sipo_p_check | hash_3rd_round) begin
			sipo_p <= 0;
		end else begin
			sipo_p <= sipo_p_nxt;
		end
	end

	assign #0.2 sipo_p_check = ( ~|sipo_p[5:2] ) & sipo_p[6] & ( &sipo_p[1:0] );
	inc_i7_o7 INC_SIPO_P ( .x( sipo_p ), .out( sipo_p_nxt ) );
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Counter for stoping SIPO PACK_S3 earlier
	always @ ( posedge sipo_p_clk ) begin
		if (sipo_p_stop) begin
			stop <= STOP_AT;
		end else begin
			stop <= sipo_p_nxt;
		end
	end
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Counter for to check the final round of SHA3-256
	always @ ( posedge ovr_rst1 or posedge hash_ans ) begin
		if (ovr_rst1) begin
			hash <= 0;
		end else begin
			hash <= hash_nxt[1:0];
		end
	end

	inc_i2_i3 INC_HASH ( .x( hash ), .out( hash_nxt ) );
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Halt_n to stop the program and export the answer
	always @ ( posedge ovr_rst1 or negedge hash_fin ) begin
		if (ovr_rst1) begin
			halt_n <= 1;
		end else begin
			halt_n <= 0;
		end
	end
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//   Counter for SIPO TERNARY 's clock2
	always @ ( posedge sipo_t1_clk ) begin
		if (ovr_rst1 ) begin
			sipo_t2 <= 0;
		end else begin
			sipo_t2 <= sipo_t2_nxt;
		end
	end

	assign sipo_t2_nxt = ~sipo_t2;
	//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
	//  Counter for LIFT enable
	always @ ( posedge sipo_t2_clk ) begin
		if (~up_rq0_done) begin
			lift <= 0;
		end else begin
			if (lift_check) begin
				lift <= 176;
			end else begin
				lift <= lift_nxt;
			end
		end
	end

	assign #0.2 lift_en = ( ~lift_check ) & ( |lift );
	assign #0.2 lift_check = lift[7] & (~lift[6]) & ( &lift[5:4] ) & ( ~|lift[3:0] );
	inc_i8_o8 INC_LIFT ( .a( lift ), .out( lift_nxt ) );
	//------------------------------------------------------------------------------
endmodule
