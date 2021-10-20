`include "ControlUnit.sv"
`include "mod3_i8_o2.sv"
`include "trit5_to_bit8.sv"
`timescale 1ns / 1ps

module testbench;
	parameter RANDOM_BITS = 16, HASH_BITS = 1088;
	wire rst, clk;
	wire [RANDOM_BITS:1] bits;
	wire [3:0] mod3;
	wire ovr_rst, fifo1_en, fio2_en, fifo2_stop, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_clk, hash_fin;
	wire [1:0] p3_count;
	wire [19:0] rm;
	wire [15:0] bytes;
	wire [HASH_BITS:1] prm;

	mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

	fifo1 FIFO1 ( .ovr_rst( ovr_rst ), .clk( fifo1_en ), .init( mod3[3:0] ), .out( rm[19:0] ) );

	trit5_to_bit8 P3_1 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[9:0] ), .count( p3_count ), .out( bytes[7:0] ) );
	trit5_to_bit8 P3_2 ( .rst1( p3_rst1 ), .rst2( p3_rst2 ), .clk( fifo1_en ), .a( rm[19:10] ), .count( p3_count ), .out( bytes[15:8] ) );

	fifo2 FIFO2 ( .ovr_rst( ovr_rst ), .clk( fifo2_en ), .stop( fifo2_stop ), .init( bytes ), .out( prm[HASH_BITS:1] ) );

	Control_Unit CU (ovr_rst, clk, fifo1_en, fifo2_en, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);

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
			out <= {init, out[19:4]};
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
			out <= {init, out[HASH_BITS:17]};
		end
	end
endmodule
