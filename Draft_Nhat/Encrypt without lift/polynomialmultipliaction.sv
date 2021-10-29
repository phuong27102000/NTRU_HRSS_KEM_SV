module polynomialmultiplication (clk,en,rin,h,e_1);
	parameter NUM_WIDTH_LENGTH_H=13;
	parameter NUM_WIDTH_LENGTH_R=2;
	parameter NUM_N=701;
	input wire en;
	input wire clk;
	input wire [1:0]rin;
	input wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]h;
	output reg [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e_1;
	wire  [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e;
	wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e_next;
	reg r,r_next;
	reg rst;
	genvar i;
	generate 
		for (i=NUM_N-1;i>=1;i=i-1) begin
			ArithmeticUnit entity_0 (.e(e[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .h(h[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .r(r), .r_next(r_next) ,.e_next(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]));
			Regfile entity_1 (.in1(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .clk(clk), .out(e[(i)*NUM_WIDTH_LENGTH_H-1:(i-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
		end
	endgenerate
	ArithmeticUnit entity_63 (.e(e[NUM_WIDTH_LENGTH_H-1:0]), .h(h[NUM_WIDTH_LENGTH_H-1:0]), .r(r), .r_next(r_next) ,.e_next(e_next[NUM_WIDTH_LENGTH_H-1:0]));
	Regfile entity_64 (.in1(e_next[NUM_WIDTH_LENGTH_H-1:0]), .clk(clk),.out(e[(NUM_N-1+1)*NUM_WIDTH_LENGTH_H-1:(NUM_N-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
	reg [12:1] m;

	always@(posedge clk) begin
		if (en) begin
			m=0;
			rst=1;
			r <= 0;
			r_next <= 0;
		end
		else begin
			if (rst==1) begin
				rst=0;
				r <= rin[0];
				r_next <= rin[1];
			end
			else begin
				if (m<699) begin 
					m=m+1;
					r <= rin[0];
					r_next<=rin[1];
					
				end
				else if (m==699) begin
					m=m+1;
					r <= 1'b0;
					r_next<=1'b0;
				end
				else if (m== 700) begin
					e_1=e;
					m=0;
				end
				else;
			end
		end
	end
endmodule
