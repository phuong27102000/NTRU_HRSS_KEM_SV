`include "mod3_i8_o2.sv"
`include "trit5_to_bit8.sv"
`include "sha3_256.sv"

module encapsulate(rst, clk, bits, k);
	parameter RANDOM_BITS = 8, HASH_BITS = 1088;
	input rst, clk;
	input [RANDOM_BITS:1] bits;
	output [256:1] k;
	wire [1:0] mod3;
	wire [7:0] trits;
	wire [9:0] rm;
	wire [RANDOM_BITS:1] reg_bits;
	wire [HASH_BITS:1] prm;
	reg [HASH_BITS:1] p;
	wire [HASH_BITS:1] s_next;
	wire ovr_rst, clk, fifo1_en, fio2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin;

	mod3_i8_o2 MOD3 ( .in( reg_bits[8:1] ) , .out( mod3[1:0] ) );

	fifo1 FIFO1 ( .clk( fifo1_en ), .rst( fifo1_rst ), .init( mod3[1:0] ), .out( rm[9:0] ) );

	trit5_to_bit8 T2B ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( clk ), .a( r ), .count( p3_count ), .out( trits ) );

	fifo2 FIFO2 ( .clk( fifo2_en ), .rst( fifo2_rst ), .init( trits ), .out( prm[HASH_BITS:0] ) );

	gen_p GEN_P ( .prm( prm ), .hash_fin( hash_fin ), .p( p ) );

	sha3_256 HASH ( .rst1( hash_rst1 ), .rst2( hash_rst2 ), .sp( hash_sp ), .ans( hash_ans ), .sp_keccak( hash_keccak ), .clk( hash_clk ), .p( p ), .out( s_next ) );

	Control_Unit CU (ovr_rst, clk, fifo1_en, fio2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin);

	always @ ( * ) begin
		if (hash_fin) begin
			p <= { 2'b10, 1'b1, 1020'0, 1'b1, prm[232:169] };
		end
		else begin
			p <= prm;
		end
	end
endmodule

module fifo1 (clk, rst, init, out);
	input rst, clk;
	input[1:0] init;
	output reg[9:0] out;

	always @ ( posedge clk ) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			out <= {init, out[9:2]};
		end
	end

endmodule

module fifo2 (clk, rst, init, out);
	parameter HASH_BITS = 1088;
	input rst, clk;
	input[7:0] init;
	output reg[HASH_BITS:1] out;

	always @ ( posedge clk ) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			out <= {init, out[HASH_BITS:8]};
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
			p[REMAIN_BITS : 1] = prm[232:169];
		end
		else begin
			p[REMAIN_BITS : 1] = prm[REMAIN_BITS : 1];
		end
	end

	assign n_fin = ~hash_fin;
	assign p[ HASH_BITS : HASH_BITS-1 ] = { hash_fin | prm[HASH_BITS], n_fin & prm[HASH_BITS-1]};
	assign p[ HASH_BITS-2 : REMAIN_BITS+1 ] = { hash_fin | prm[HASH_BITS-2], {ZERO_BITS{n_fin}} & prm[HASH_BITS-3 : REMAIN_BITS+2], hash_fin | prm[REMAIN_BITS+1] }

endmodule

module Control_Unit(ovr_rst1, clk, fifo1_en, fifo2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);
	input ovr_rst1, clk;
	output fifo1_en, fio2_en, fifo1_rst, fifo2_rst, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin;
	reg [2:0] fifo1;
	reg [7:0] fifo2;
	reg [1:0] hash;
	reg ovr_rst2;

	assign fifo1_en = clk;
	assign fifo2_en = ( |fifo1[1:0] ) & (~fifo1[0]); //fifo1 = 1,2,3
	assign fifo1_rst = ~( |fifo1 ); //fifo1 = 0
	assign fifo2_rst = ~( |fifo2 ); //fifo2 = 0
	assign p3_rst1 = fifo1_rst;
	assign p3_rst2 = ~( |{ fifo1[2:1], ~fifo2[0] } ); //fifo1 = 1
	assign hash_rst1 = fifo2_rst & (~hash[1]) & hash[0]; //fifo2_rst = 1 and hash = 1
	assign hash_rst2 = ~( |{ fifo2[7:3], ~fifo2[2], fifo2[1:0] } ); //fifo2 = 4
	assign hash_sp = ~( |{ fifo2[7:2], ~( ^fifo2[1:0] ) } ); //fifo2 = 1,2
	assign hash_ans = ~( |{ fifo2[7:5], ~( &fifo2[4:1] ) ,fifo2[0] ) } ); //fifo2 = 30
	assign hash_keccak = fifo2[0];
	assign hash_clk = fifo2_en;
	assign hash_fin = ( hash[1] & hash[0] );


	always @ ( posedge fifo1_en ) begin
		if (ovr_rst1 | (fifo1 == 5)) begin
			fifo1 <= 0;
			ovr_rst2 <= 1;
		end
		else begin
			fifo1 <= fifo1 + 1;
			ovr_rst2 <= 0;
		end
	end

	always @ ( posedge fifo2_en ) begin
		if (ovr_rst2 | (fifo2 == 137)) begin
			fifo2 <= 0;
		end
		else begin
			fifo2 <= fifo2 + 1;
		end
	end

	always @ ( posedge ovr_rst1 or posedge hash_ans ) begin
		if (ovr_rst2) begin
			hash <= 0;
		end
		else begin
			hash <= hash + 1;
		end
	end

endmodule
