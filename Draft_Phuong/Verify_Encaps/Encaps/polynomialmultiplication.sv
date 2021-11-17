`timescale 1ns / 1ps

module polynomialmultiplication (clk,en,rin,h,e);
	parameter NUM_WIDTH_LENGTH_H=13;
	parameter NUM_WIDTH_LENGTH_R=2;
	parameter NUM_N=701;
	input wire en;
	input wire clk;
	input wire [1:0]rin;
	input wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]h;
	output wire  [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e;
	wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e_next;
	reg r,r_next;
	reg rst;
	wire lcl_clk, halt, pre_halt;

	genvar i;
	generate
		for (i=NUM_N-1;i>=1;i=i-1) begin
			ArithmeticUnit entity_0 (.e(e[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .h(h[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .r(r), .r_next(r_next) ,.e_next(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]));
			Regfile entity_1 (.in1(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .clk(lcl_clk), .out(e[(i)*NUM_WIDTH_LENGTH_H-1:(i-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
		end
	endgenerate
	ArithmeticUnit entity_63 (.e(e[NUM_WIDTH_LENGTH_H-1:0]), .h(h[NUM_WIDTH_LENGTH_H-1:0]), .r(r), .r_next(r_next) ,.e_next(e_next[NUM_WIDTH_LENGTH_H-1:0]));
	Regfile entity_64 (.in1(e_next[NUM_WIDTH_LENGTH_H-1:0]), .clk(lcl_clk),.out(e[(NUM_N-1+1)*NUM_WIDTH_LENGTH_H-1:(NUM_N-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
	reg [12:1] m;

	assign #0.2 halt = (m==700);
	assign #0.2 pre_halt = (m==699);
	assign lcl_clk = clk & (~halt);

	always@(posedge lcl_clk or posedge en) begin
		if (en) begin
			m <= 0;
			rst <= 1;
			r <= 0;
			r_next <= 0;
		end
		else begin
			if (rst==1) begin
				rst <= 0;
				r <= rin[0];
				r_next <= rin[1];
			end
			else begin
				if (~(pre_halt | halt)) begin
					m <= m+1;
					r <= rin[0];
					r_next<=rin[1];

				end
				else if (pre_halt) begin
					m <= m+1;
					r <= 1'b0;
					r_next <= 1'b0;
				end
				else;
			end
		end
	end
endmodule

module ArithmeticUnit (e, h, r, r_next ,e_next);
	parameter NUM_WIDTH_LENGTH=13;
	input [NUM_WIDTH_LENGTH-1:0] e, h;
	input r,r_next;
	output [NUM_WIDTH_LENGTH-1:0]e_next;
	wire [NUM_WIDTH_LENGTH-1:0] out_xor,e_adder;
	Xor_N_bit entity_0 ( .h(h), .r(r_next), .out_xor(out_xor));
	carryselectadder entity_1 ( .in1(e), .in2(out_xor), .cin(r_next) ,.out(e_adder));
	mux_N entity_2 (.in1(e), .in2(e_adder), .sel(r), .out(e_next));
endmodule
