`include "add_2i13_o13.sv"
module unpack_rq0 (rst, clk, even, odd, h_mem, done);
	parameter H_BITS = 9113;
	input clk, rst;
	input [12:0] even, odd, check_holder;
	output [H_BITS:1] h_mem;
	output done;
	wire [12:0] out;
	reg [12:0] store_even, store_odd;
	wire [12:0] next, next_even, next_odd;

	always @ ( posedge clk ) begin
		if (rst) begin
			store_even <= 13'b1_1111_1111_1111;
			store_odd <= 13'b0;
		end
		else begin #0.2
			store_even <= next_even;
			store_odd <= next_odd;
		end
	end

	add_2i13_o13 ADD1 ( .x1( even ), .x2( store_even ), .out( next_even ) );
	add_2i13_o13 ADD2 ( .x1( odd ), .x2( store_odd ), .out( next_odd ) );
	add_2i13_o13 ADD3 ( .x1( store_even ), .x2( store_odd ), .out( next ) );
	sipoH SIPOH ( .ovr_rst(rst), .clk(clk), .init1( {odd, even} ), .init2(out), .out(h_mem), .done(done) );
	assign out = ~next;
	
endmodule // unpack_rq0

module sipoH (ovr_rst, clk, init1, init2, out, done);
	parameter H_BITS = 9113, EVEN_HALF_H_BITS = 4563;
	input ovr_rst, clk;
	input[25:0] init1;
	input[12:0] init2;
	output reg[H_BITS:1] out;
	output done;
	wire[12:0] even, odd;
	reg last, done;

	always @ ( posedge ovr_rst or posedge clk1 ) begin
		if(ovr_rst) begin
			out[EVEN_HALF_H_BITS-1:1] <= 0;
			out[EVEN_HALF_H_BITS] <= 1;
			done <= 0;
		end
		else begin
			#0.1 { out[EVEN_HALF_H_BITS:1],done } <= { even, out[EVEN_HALF_H_BITS:13] };
		end
	end

	always @ ( posedge ovr_rst or posedge clk2 ) begin
		if(ovr_rst) begin
			out[H_BITS-1 : EVEN_HALF_H_BITS+1] <= 1;
			out[H_BITS] <= 1;
			last <= 0;
		end
		else begin
			#0.1 { out[H_BITS : EVEN_HALF_H_BITS+1], last }  <= { odd, out[H_BITS : EVEN_HALF_H_BITS+13] };
		end
	end

	assign even = last ? init2 : init1[12:0];
	assign odd = init1[25:13];
	assign clk1 = clk & (~done);
	assign clk2 = clk1 & (~last);
endmodule
