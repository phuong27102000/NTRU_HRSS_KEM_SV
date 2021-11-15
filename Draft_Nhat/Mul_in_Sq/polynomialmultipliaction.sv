module polynomialmultiplication (clk,en,c,h,e_1);
	parameter NUM_WIDTH_LENGTH_H=13;
	parameter NUM_N=701;

	input wire en;
	input wire clk;
	input wire [NUM_WIDTH_LENGTH_H:1] c;
	input wire [(NUM_N-1)*NUM_WIDTH_LENGTH_H-1:0]h;
	output wire [NUM_N*NUM_WIDTH_LENGTH_H-14:0] e_1;

	wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e;
	wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]hq;
	wire [NUM_N*NUM_WIDTH_LENGTH_H-1:0]e_next;
	wire clk_1;
	reg [NUM_WIDTH_LENGTH_H:1] c1;
	reg t;
	reg rst;
	
	assign hq = {13'd0,h};
	genvar i;
	generate 
		for (i=NUM_N-1;i>=1;i=i-1) begin
			ArithmeticUnit entity_0 (.e(e[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .hq(hq[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .c1(c1) ,.e_next(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]));
			Regfile entity_1 (.in1(e_next[(i+1)*NUM_WIDTH_LENGTH_H-1:i*NUM_WIDTH_LENGTH_H]), .clk(clk_1), .out(e[(i)*NUM_WIDTH_LENGTH_H-1:(i-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
		end
	endgenerate
	ArithmeticUnit entity_63 (.e(e[NUM_WIDTH_LENGTH_H-1:0]), .hq(hq[NUM_WIDTH_LENGTH_H-1:0]), .c1(c1) ,.e_next(e_next[NUM_WIDTH_LENGTH_H-1:0]));
	Regfile entity_64 (.in1(e_next[NUM_WIDTH_LENGTH_H-1:0]), .clk(clk_1),.out(e[(NUM_N-1+1)*NUM_WIDTH_LENGTH_H-1:(NUM_N-1)*NUM_WIDTH_LENGTH_H]),.rst(rst));
	reg [12:1] m;
	
	assign clk_1 = clk & t;
	always@(posedge clk) begin
		if (en) begin
			m=0;
			rst=1;
			c1 <= 0;
		end
		else begin
			if (rst==1) begin
				rst=0;
				c1 <= c;
			end
			else begin
				if (m<NUM_N-2) begin 
					m <= m+1;
					c1 <= c;
					
				end
				else if (m==NUM_N-2) begin
					m <= m+1;
					c1 <= c;
				end
				else if (m== NUM_N-1) begin
					m <= m;
					c1 <= 0;
				end
				else
					m <= m;
			end
		end
	end

	always@(negedge clk) begin
		if (m==NUM_N-1)
			t <= 0;
		else 
			t <= 1;
	end
	
	wire [13:1] e_inv;
	Carryselectadder Carryselectadder ( .in1(~e[NUM_N*NUM_WIDTH_LENGTH_H-1:NUM_N*NUM_WIDTH_LENGTH_H-13]), .in2(13'd0), .cin(1'b1) ,.out(e_inv));
	generate
		for ( i=0; i<= NUM_N*NUM_WIDTH_LENGTH_H-14; i=i+13) begin
			Carryselectadder Carryselectadder ( .in1(e[i+12:i]), .in2(e_inv), .cin(1'b0) ,.out(e_1[i+12:i]));
		end
	endgenerate
endmodule
