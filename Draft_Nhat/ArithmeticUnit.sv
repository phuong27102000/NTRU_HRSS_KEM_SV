module ArithmeticUnit (e, h, r, r_next ,e_next);
	input [31:0] e, h;
	input r,r_next;
	output [31:0]e_next;
	wire [31:0] out_xor,e_adder;
	Xor_N_bit entity_0 ( .h(h), .r(r_next), .out_xor(out_xor));
	carryselectadder entity_1 ( .in1(e), .in2(out_xor), .cin(r_next) ,.out(e_adder));
	mux_N entity_2 (.in1(e), .in2(e_adder), .sel(r), .out(e_next));
endmodule
