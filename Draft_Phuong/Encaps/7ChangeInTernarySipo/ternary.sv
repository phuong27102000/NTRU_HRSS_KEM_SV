// `include "mod3_i8_o2.sv"

module ternary(rst, clk1, clk2, bits, rm);
	parameter RANDOM_BITS = 16, R_BITS = 1400, TER_BITS = 20;
	input rst, clk1, clk2;
	input [RANDOM_BITS:1] bits;
	output [R_BITS+TER_BITS:1] rm;
	wire[3:0] mod3;

    mod3_i8_o2 MOD3_1 ( .in( bits[8:1] ) , .out( mod3[1:0] ) );
	mod3_i8_o2 MOD3_2 ( .in( bits[16:9] ) , .out( mod3[3:2] ) );

    sipo_t SIPO_T ( .rst( rst ), .clk1( clk1 ), .clk2( clk2 ), .init( mod3[3:0] ),
	.out( rm ) );

endmodule // ternary

module sipo_t (rst, clk1, clk2, init, out);
	parameter R_BITS = 1400, TER_BITS = 20;
	input rst, clk1, clk2;
	input[3:0] init;
	output reg[R_BITS+TER_BITS:1] out;

	always @ ( posedge rst or posedge clk1 ) begin
		if(rst) begin
			out[R_BITS+TER_BITS : R_BITS+1] <= 0;
		end
		else begin
			#0.3 out[R_BITS+TER_BITS : R_BITS+1] <= {init, out[R_BITS+TER_BITS : R_BITS+5]};
		end
	end

	always @ ( posedge rst or posedge clk2 ) begin
		if(rst) begin
			out[R_BITS:1] <= 0;
		end
		else begin
			#0.3 {out[R_BITS:1]} <= {out[R_BITS+TER_BITS : R_BITS+TER_BITS-3], out[R_BITS:5]};
		end
	end

endmodule
