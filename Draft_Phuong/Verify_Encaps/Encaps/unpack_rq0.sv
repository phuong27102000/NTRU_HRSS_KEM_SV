`timescale 1ns / 1ps

module unpack_rq0 (rst, clk, done, h_in, h);
	parameter H_BITS = 9113;
	input clk, rst, done;
	input [9104:1] h_in;
	output [H_BITS:1] h;
	wire [12:0] even, odd;
	reg [12:0] store_even, store_odd;
	wire [12:0] next, next_even, next_odd;
	wire b2b_clk, lcl_clk;

	always @ ( posedge lcl_clk ) begin
		if (rst) begin
			store_even <= 13'b1_1111_1111_1111;
			store_odd <= 13'b0;
		end
		else begin #0.2
			store_even <= next_even;
			store_odd <= next_odd;
		end
	end

	assign even = h[13:1];
	assign odd = h[26:14];

	assign lcl_clk = clk & (~done);

	bytes_to_bits_h B2B ( .rst(rst), .clk(lcl_clk), .h_in(h_in), .h(h[H_BITS-13:1]) );

	add_2i13_o13 ADD1 ( .x1( even ), .x2( store_even ), .out( next_even ) );
	add_2i13_o13 ADD2 ( .x1( odd ), .x2( store_odd ), .out( next_odd ) );
	add_2i13_o13 ADD3 ( .x1( store_even ), .x2( store_odd ), .out( next ) );
	assign h[H_BITS:H_BITS-12] = ~next;

endmodule // unpack_rq0
