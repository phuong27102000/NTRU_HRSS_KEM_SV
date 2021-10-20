module Control_Unit(ovr_rst1, ovr_rst2, ex_clk, halt_n, sipo_u_clk, sipo_t_clk, sipo_p_clk,
	sipo_p_stop, p3_rst1, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans,
	hash_keccak, hash_clk, hash_fin);
	parameter STOP_AT = 5;
	input ovr_rst1, ex_clk;
	output halt_n, sipo_u_clk, sipo_t_clk, sipo_p_clk, sipo_p_stop, p3_rst1;
	output hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk;
	output hash_fin, ovr_rst2;
	output [1:0] p3_count;

	reg [2:0] sipo_t;
	reg [7:0] sipo_p, stop;
	reg [1:0] hash;
	reg ovr_rst2;
	reg halt_n;

	assign sipo_t_clk = ex_clk & halt_n;
	assign sipo_u_clk = ex_clk & halt_n;

	// assign sipo_p_clk = sipo_t[1] & ( ~sipo_t[2] ); //sipo_t = 2,3
	assign sipo_p_clk = ( ^sipo_t[1:0] ) & ( ~sipo_t[2] ); //sipo_t = 1,2
	assign #0.3 sipo_p_stop = hash[1] & stop[2] & stop[0] & ( ~|{ stop[7:3], stop[1] } ); //hash >= 2 and stop = STOP_AT

	// assign #0.3 p3_rst1 = ~( |{ sipo_t[2:1], ~sipo_t[0] } ); //sipo_t = 1
	// assign #0.3 p3_rst2 = ~( |{ sipo_t[2], ~sipo_t[1], sipo_t[0] } ); //sipo_t = 2
	// assign #0.3 p3_count = { |sipo_t[2:1], sipo_t[0] }; // ( sipo_t, p3_count ) = ( 3, 3 ), ( 4, 2 ), ( 0, 0 ), ( 1, 1 )
	assign #0.3 p3_rst1 = ~( |sipo_t ); //sipo_t = 0
	// assign #0.3 p3_rst2 = ~( |{ sipo_t[2:1], ~sipo_t[0] } ); //sipo_t = 1
	assign #0.3 p3_count = { sipo_t[1], sipo_t[0] }; // ( sipo_t, p3_count ) = ( 1, 1 ), ( 2, 2 ), ( 3, 3 ), ( 4, 0 )
	// assign #0.3 p3_count = { sipo_t[2] ^ sipo_t[0], sipo_t[1] }; // ( sipo_t, p3_count ) = ( 2, 1 ), ( 3, 3 ), ( 4, 2 ), ( 0, 0 )

	// assign hash_rst1 = ~( |sipo_p ) & (~hash[1]) & hash[0]; //sipo_p = 0 and hash = 1
	// assign hash_rst2 = ~( |{ sipo_p[7:1] } ); //sipo_p = 0,1
	// assign #0.2 hash_sp = ~( |sipo_p); //sipo_p = 0
	assign #0.5 hash_rst1 = ~( |{ sipo_p[7:1], ~sipo_p[0] } ) & (~hash[1]) & hash[0]; //sipo_p = 1 and hash = 1
	assign #0.5 hash_rst2 = ~( |{ sipo_p[7:2], ~sipo_p[1] } ); //sipo_p = 2,3
	assign #0.5 hash_sp = ~( |{ sipo_p[7:1], ~sipo_p[0] } ); //sipo_p = 1
	// assign hash_ans = ~( |{ sipo_p[7:6], ~( &sipo_p[5:4] ), sipo_p[3:2], ~sipo_p[1], sipo_p[0] } ); //sipo_p = 50
	assign hash_ans = ~( |{ sipo_p[7:6], ~( &sipo_p[5:4] ), sipo_p[3], ~sipo_p[2], sipo_p[1:0] } ); //sipo_p = 52
	assign hash_keccak = sipo_p[0];
	assign hash_clk = sipo_p_clk;
	assign hash_fin = ( hash[1] & hash[0] );
	assign hash_3rd_round = hash_fin & hash_ans;

//------------------------------------------------------------------------------
//  Counter for SIPO TERNARY
	always @ ( posedge sipo_t_clk ) begin
		if (ovr_rst1 | (sipo_t == 4)) begin
			sipo_t <= 0;
		end else begin
			sipo_t <= sipo_t + 1;
		end
	end
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
//  Counter for SIPO PACK_S3
	always @ ( posedge sipo_p_clk ) begin
		if (ovr_rst2 | (sipo_p == 67) | hash_3rd_round) begin
			sipo_p <= 0;
		end else begin
			sipo_p <= sipo_p + 1;
		end
	end
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Counter for stoping SIPO PACK_S3 earlier
	always @ ( posedge sipo_p_clk ) begin
		if (sipo_p_stop) begin
			stop <= STOP_AT;
		end else begin
			stop <= sipo_p + 1;
		end
	end
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Counter for to check the final round of SHA3-256
	always @ ( posedge ovr_rst1 or posedge hash_ans ) begin
		if (ovr_rst1) begin
			hash <= 0;
		end else begin
			hash <= hash + 1;
		end
	end
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
