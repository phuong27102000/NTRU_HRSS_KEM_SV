// `include "inc.sv"
module Control_Unit(ovr_rst1, ovr_rst2, ex_clk, halt_n, sipo_u_clk, sipo_t_clk, sipo_p_clk,
	sipo_p_stop, p3_rst1, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans,
	hash_keccak, hash_clk, hash_fin);
	parameter STOP_AT = 5;
	input ovr_rst1, ex_clk;
	output halt_n, sipo_u_clk, sipo_t_clk, sipo_p_clk, sipo_p_stop, p3_rst1;
	output hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk;
	output hash_fin, ovr_rst2;
	output [1:0] p3_count;

	reg [2:0] sipo_t, sipo_t_nxt, hash_nxt;
	reg [6:0] sipo_p, sipo_p_nxt, stop;
	reg [1:0] hash;
	reg ovr_rst2;
	reg halt_n;
	wire sipo_t_check, sipo_p_check;

	assign sipo_t_clk = ex_clk & halt_n;
	assign sipo_u_clk = ex_clk & halt_n;

	assign sipo_p_clk = ( ^sipo_t[1:0] ) & ( ~sipo_t[2] ); //sipo_t = 1,2
	assign #0.3 sipo_p_stop = hash[1] & stop[2] & stop[0] & ( ~|{ stop[6:3], stop[1] } ); //hash >= 2 and stop = STOP_AT

	assign #0.3 p3_rst1 = ~( |sipo_t ); //sipo_t = 0
	assign #0.3 p3_count = { sipo_t[1], sipo_t[0] }; // ( sipo_t, p3_count ) = ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 0 )

	assign #0.5 hash_rst1 = ~( |{ sipo_p[6:1], ~sipo_p[0] } ) & (~hash[1]) & hash[0]; //sipo_p = 1 and hash = 1
	assign #0.5 hash_rst2 = ~( |{ sipo_p[6:2], ~sipo_p[1] } ); //sipo_p = 2,3
	assign #0.5 hash_sp = ~( |{ sipo_p[6:1], ~sipo_p[0] } ); //sipo_p = 1
	assign hash_ans = ~( |{ sipo_p[6], ~( &sipo_p[5:4] ), sipo_p[3], ~sipo_p[2], sipo_p[1:0] } ); //sipo_p = 52
	assign hash_keccak = sipo_p[0];
	assign hash_clk = sipo_p_clk;
	assign hash_fin = ( hash[1] & hash[0] );
	assign hash_3rd_round = hash_fin & hash_ans;

	//------------------------------------------------------------------------------
	//  Counter for SIPO TERNARY, reset when sipo_t == 4
	always @ ( posedge sipo_t_clk ) begin
		if (ovr_rst1 | sipo_t_check) begin
			sipo_t <= 0;
		end else begin
			sipo_t <= sipo_t_nxt;
		end
	end

	assign #0.2 sipo_t_check = sipo_t[2];
	inc_i2_i3 INC_SIPO_T ( .x( sipo_t[1:0] ), .out( sipo_t_nxt ));
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
	inc_i7_o7 INC_SIPO_P ( .x( sipo_p ), .out( sipo_p_nxt ));
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

	inc_i2_i3 INC_HASH ( .x( hash ), .out( hash_nxt ));
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

endmodule
