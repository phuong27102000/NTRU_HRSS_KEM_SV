`include "mod3_i8_o2.sv"
`include "trit5_to_bit8.sv"
`include "sha3_256.sv"

module encapsulate(rst, clk, bits, k);
	parameter RANDOM_BITS = 16, HASH_BITS = 1088;
	input rst, clk;
	input [RANDOM_BITS:1] bits;
	output [256:1] k;
	wire [3:0] mod3;
	wire ovr_rst, clk, fifo1_en, fio2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin;
	wire [1:0] p3_count;
	wire [19:0] rm;
	wire [15:0] trits;
	wire [HASH_BITS:1] prm;
	reg [HASH_BITS:1] p;
	wire [HASH_BITS:1] s_next;
	reg [256:1] k;

	mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

	fifo1 FIFO1 ( .clk( fifo1_en ), .rst( fifo1_rst ), .init( mod3[3:0] ), .out( rm[19:0] ) );

	trit5_to_bit8 P3_1 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[9:0] ), .count( p3_count ), .out( trits[7:0] ) );
	trit5_to_bit8 P3_2 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[19:10] ), .count( p3_count ), .out( trits[15:8] ) );

	fifo2 FIFO2 ( .clk( fifo2_en ), .rst( fifo2_rst ), .init( trits ), .out( prm[HASH_BITS:0] ) );

	gen_p GEN_P ( .prm( prm ), .hash_fin( hash_fin ), .p( p ) );

	sha3_256 HASH ( .ovr_rst( ovr_rst ), .rst1( hash_rst1 ), .rst2( hash_rst2 ), .sp( hash_sp ), .ans( hash_ans ), .sp_keccak( hash_keccak ), .clk( hash_clk ), .p( p ), .out( s_next ) );

	Control_Unit CU (ovr_rst, clk, halt_n, fifo1_en, fifo2_en, fifo1_rst, fifo2_rst, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);

	always @ ( posedge clk ) begin
		if (halt_n) begin
			k <= 0;
		end
		else begin
			k <= s_next;
		end
	end

endmodule

module fifo1 (clk, rst, init, out);
	input rst, clk;
	input[3:0] init;
	output reg[19:0] out;

	always @ ( posedge clk ) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			out <= {init, out[19:4]};
		end
	end

endmodule

module fifo2 (clk, rst, stop, init, out);
	parameter HASH_BITS = 1088;
	input rst, clk;
	input[15:0] init;
	output reg[HASH_BITS:1] out;
	wire local_clk;

	assign local_clk = clk & (~stop);

	always @ ( posedge local_clk ) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			out <= {init, out[HASH_BITS:16]};
		end
	end
endmodule

module gen_p(prm, hash_fin, p);
	parameter HASH_BITS = 1088, REMAIN_BITS = 64, ZERO_BITS = 1020; //ZERO_BITS = HASH_BITS - REMAIN_BITS - 4
	input[HASH_BITS:1] prm;
	input hash_fin;
	output[HASH_BITS:1] p;
	reg [REMAIN_BITS:1] p;

	always @ ( * ) begin
		if(hash_fin) begin
			p[REMAIN_BITS:1] <= prm[ HASH_BITS : HASH_BITS - REMAIN_BITS + 1 ];
		end
		else begin
			p[REMAIN_BITS:1] <= prm[REMAIN_BITS:1];
		end
	end

	assign n_fin = ~hash_fin;
	assign p[ HASH_BITS : HASH_BITS-1 ] = { hash_fin | prm[HASH_BITS], n_fin & prm[HASH_BITS-1]};
	assign p[ HASH_BITS-2 : REMAIN_BITS+1 ] = { hash_fin | prm[HASH_BITS-2], {ZERO_BITS{n_fin}} & prm[HASH_BITS-3 : REMAIN_BITS+2], hash_fin | prm[REMAIN_BITS+1] }

endmodule

module Control_Unit(ovr_rst1, ex_clk, halt_n, fifo1_en, fifo2_en, fifo1_rst, fifo2_rst, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);
	parameter STOP_AT = 5;
	input ovr_rst1, ex_clk;
	output halt_n, fifo1_en, fifo2_en, fifo1_rst, fifo2_rst, fifo2_stop, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin;
	output [1:0] p3_count;
	reg [2:0] fifo1;
	reg [7:0] fifo2, stop;
	reg [1:0] hash;
	reg ovr_rst2;
	wire clk;
	reg halt_n;

	assign clk = ex_clk & halt_n;
	assign fifo1_en = clk;
	assign fifo2_en = ( |fifo1[1:0] ) & ( ~fifo1[2] ); //fifo1 = 1,2,3
	assign fifo1_rst = ~( |fifo1 ); //fifo1 = 0
	assign fifo2_rst = ~( |fifo2 ); //fifo2 = 0
	assign fifo2_stop = hash[1] & stop[2] & stop[0] & ( ~|{ stop[7:3], stop[1] } ); //hash >= 2 and stop = STOP_AT
	assign p3_rst1 = fifo1_rst;
	assign p3_rst2 = ~( |{ fifo1[2:1], ~fifo1[0] } ); //fifo1 = 1
	assign p3_count = { fifo1[2], fifo1[0] }; // ( fifo1, p3_count ) = ( 2, 0 ), ( 3, 1 ), ( 4, 2 ), ( 5, 3 )
	assign hash_rst1 = fifo2_rst & (~hash[1]) & hash[0]; //fifo2_rst = 1 and hash = 1
	assign hash_rst2 = ~( |{ fifo2[7:3], ~fifo2[2], fifo2[1:0] } ); //fifo2 = 4
	assign hash_sp = ~( |{ fifo2[7:2], ~( ^fifo2[1:0] ) } ); //fifo2 = 1,2
	assign hash_ans = ~( |{ fifo2[7:5], ~( &fifo2[4:1] ), fifo2[0] } ); //fifo2 = 30
	assign hash_keccak = fifo2[0];
	assign hash_clk = fifo2_en;
	assign hash_fin = ( hash[1] & hash[0] );
	assign hash_3rd_round = hash_fin & hash_ans;


	always @ ( posedge fifo1_en ) begin
		if (ovr_rst1 | (fifo1 == 5)) begin
			fifo1 <= 0;
		end
		else begin
			fifo1 <= fifo1 + 1;
		end
	end

	always @ ( posedge fifo2_en or posedge ovr_rst1 ) begin
		if (ovr_rst1) begin
			ovr_rst2 <= 1;
		end
		else begin
			ovr_rst2 <= 0;
		end
	end

	always @ ( posedge fifo2_en ) begin
		if (ovr_rst2 | (fifo2 == 68) | hash_3rd_round) begin
			fifo2 <= 0;
		end
		else begin
			fifo2 <= fifo2 + 1;
		end
	end

	always @ ( posedge fifo2_en ) begin
		if (fifo2_stop) begin
			stop <= STOP_AT;
		end
		else begin
			stop <= fifo2 + 1;
		end
	end

	always @ ( posedge ovr_rst1 or posedge hash_ans ) begin
		if (ovr_rst1) begin
			hash <= 0;
		end
		else begin
			hash <= hash + 1;
		end
	end

	always @ ( posedge ovr_rst1 or negedge hash_fin ) begin
		if (ovr_rst1) begin
			halt_n <= 1;
		end
		else begin
			halt_n <= 0;
		end
	end

endmodule
