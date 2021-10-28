module Xor_N_bit ( h, r, out_xor);
	parameter NUM_WIDTH_LENGTH=13;
	input [NUM_WIDTH_LENGTH-1:0] h;
	input r;
	output [NUM_WIDTH_LENGTH-1:0] out_xor;
	assign out_xor=h^{NUM_WIDTH_LENGTH{r}};
endmodule
