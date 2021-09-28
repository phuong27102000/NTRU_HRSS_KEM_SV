module mod3 (in, clk, out);
	parameter NUM_WIDTH_LENGTH =32;
	input wire [NUM_WIDTH_LENGTH-1:0] in;
	input wire clk;
	output reg [1:0]out;
	integer i;
	reg [1:0]state;
	always @(negedge clk) begin
	state=0;
	for (i=NUM_WIDTH_LENGTH-1;i>=0;i=i-1) begin
	case(state)
	2'b00: begin if (in[i]==0) state=0; else state=1; end
	2'b01: begin if (in[i]==0) state=2; else state=0; end
	2'b10: begin if (in[i]==0) state=1; else state=2; end
	endcase
	end
	out=state;
	end

endmodule
