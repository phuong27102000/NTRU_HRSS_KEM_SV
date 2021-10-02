`include "mux.sv"
module mod3_i8_o1_excount(rst, clk, a, out, count);   
    
//8 bit in, after 4 periods, return modulo 3 of in
//rst must be turned off after in taking datas at least 1 period of clk
//external count
    
  	input rst,clk;
	input [7:0] a;
    input [1:0] count;
	output [1:0] out;
    wire [1:0] regin;
	reg [1:0] now, then;
	parameter [1:0] state0 = 2'b00, state1 = 2'b01, state2 = 2'b11;
	
	always @(regin or now)
		case (now)
			state0: case (regin)
				2'b00:	then = now;
				2'b01:	then = state1;
				2'b10:	then = state2;
				2'b11:	then = now;
				default: then = 2'bxx;
				endcase
			state1: case (regin)
				2'b00:	then = now;
				2'b01:	then = state2;
				2'b10:	then = state0;
				2'b11:	then = now;
				default: then = 2'bxx;
				endcase
			state2: case (regin)
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
			now <= state0;
		end
		else begin
			now <= then;
        end
    
    mux_i4_o1 MUX1 ({a[6],a[4],a[2],a[0]}, count, regin[0]);
    mux_i4_o1 MUX2 ({a[7],a[5],a[3],a[1]}, count, regin[1]);
    
	assign out = now;
endmodule