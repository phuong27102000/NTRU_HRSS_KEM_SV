`include "add_2i13_o13.sv"
module unpack_rq0 (clk, rst, x, out);
	input clk, rst;
	input [12:0] x, check_holder;
	output [12:0] out;
	reg [12:0] store;
	wire [12:0] next;

	always @ ( posedge clk ) begin
		if (rst) begin
			store <= 13'b1_1111_1111_1111;
		end
		else begin
			store <= next;
		end
	end

	add_2i13_o13 ADD ( .x1( x ), .x2( store ), .out( next ) );
	assign out = ~store;

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end
endmodule // unpack_rq0
