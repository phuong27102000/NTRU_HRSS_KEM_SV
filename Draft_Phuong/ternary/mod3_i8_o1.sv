module mod3_i8_o1(rst, clk, in, out);   
//8 bit in, after 4 periods, return modulo 3 of in
  	input rst,clk;
	input [7:0] in;
	output [1:0] out;
	reg [7:0] regin;
	reg [1:0] now, then;
	parameter [1:0] state0 = 2'b00, state1 = 2'b01, state2 = 2'b11;
	
	always @(regin[1:0] or now)
		case (now)
			state0: case (regin[1:0])
				2'b00:	then = now;
				2'b01:	then = state1;
				2'b10:	then = state2;
				2'b11:	then = now;
				default: then = 2'bxx;
				endcase
			state1: case (regin[1:0])
				2'b00:	then = now;
				2'b01:	then = state2;
				2'b10:	then = state0;
				2'b11:	then = now;
				default: then = 2'bxx;
				endcase
			state2: case (regin[1:0])
				2'b00:	then = now;
				2'b01:	then = state0;
				2'b10:	then = state1;
				2'b11:	then = now;
				default: then = 2'bxx;
				endcase
			default: then = 2'bxx;
		endcase
		
	always @(posedge clk)
		if (rst) begin
			regin <= in;
			now <= state0;
		end
		else begin
			regin <= regin >> 2;
			now <= then;
        end
	assign out = now;
endmodule