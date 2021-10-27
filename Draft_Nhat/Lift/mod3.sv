module mod3 (in, out);
	parameter NUM_WIDTH_LENGTH =14;
	input wire [NUM_WIDTH_LENGTH-1:0] in;
	output reg [12:0]out;
	integer i;
	reg [12:0]state;
	always_comb begin
	state=0;
	for (i=NUM_WIDTH_LENGTH-1;i>=0;i=i-1) begin
	case(state)
	13'd0: begin if (in[i]==0) state=0; else state=1; end
	13'd1: begin if (in[i]==0) state=13'd8191; else state=0; end
	13'd8191: begin if (in[i]==0) state=1; else state=13'd8191; end
	endcase
	end
	out=state;
	end

endmodule
