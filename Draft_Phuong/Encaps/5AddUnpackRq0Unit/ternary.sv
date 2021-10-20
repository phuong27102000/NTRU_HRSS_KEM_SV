`include "mod3_i8_o2.sv"

module ternary(rst, clk, bits, rm, done);
	parameter RANDOM_BITS = 16, RM_BITS = 2800;
	input rst, clk;
	input [RANDOM_BITS:1] bits;
	output [RM_BITS:1] rm;
	output done;
	wire[3:0] mod3;

    mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

    sipo_t SIPO_T ( .rst( rst ), .clk( clk ), .init( mod3[3:0] ), .out( rm ), .done( done ) );

endmodule // ternary

module sipo_t (rst, clk, init, out, done);
	parameter RM_BITS = 2800;
	input rst, clk;
	input[3:0] init;
	output reg[RM_BITS:1] out;
	output done;
	reg done;

	assign local_clk = clk & (~done);

	always @ ( posedge rst or posedge local_clk ) begin
		if(rst) begin
			out[RM_BITS-1:1] <= 0;
			out[RM_BITS] <= 1;
			done <= 0;
		end
		else begin
			#0.3 {out, done} <= {init, out[RM_BITS:4]};
		end
	end
endmodule
