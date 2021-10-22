// `include "trit5_to_bit8.sv"

module pack_s3(ovr_rst, rst, clk1, clk2, stop, count, rm, prm);
	parameter RM_BITS = 2800, HASH_BITS = 1088;
 	input [1:0] count;
	input ovr_rst, rst, clk1, clk2, stop;
	input [19:0] rm;
	output [HASH_BITS:1] prm;

	wire [15:0] bytes;

	trit5_to_bit8 P3_1 ( .rst( rst ), .clk( clk1 ), .a( rm[9:0] ), .count( count ), .out( bytes[7:0] ) );
	trit5_to_bit8 P3_2 ( .rst( rst ), .clk( clk1 ), .a( rm[19:10] ), .count( count ), .out( bytes[15:8] ) );

	sipo_p SIPO_P ( .rst( ovr_rst ), .clk( clk2 ), .stop( stop ), .init( bytes ), .out( prm[HASH_BITS:1] ) );

endmodule // pack_s3

module sipo_p (rst, clk, stop, init, out);
	parameter HASH_BITS = 1088;
	input rst, clk, stop;
	input[15:0] init;
	output reg[HASH_BITS:1] out;
	wire local_clk;

	assign local_clk = clk & (~stop);

	always @ ( posedge rst or posedge local_clk ) begin
		if(rst) begin
			out <= 0;
		end
		else begin
			#0.1 out <= {init, out[HASH_BITS:17]};
		end
	end
endmodule
