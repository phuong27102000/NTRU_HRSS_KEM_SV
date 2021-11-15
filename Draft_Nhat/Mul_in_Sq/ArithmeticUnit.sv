module ArithmeticUnit (e, hq, c1, e_next);
	parameter NUM_WIDTH_LENGTH=13;
	input wire[NUM_WIDTH_LENGTH-1:0] e, hq,c1;
	output wire [NUM_WIDTH_LENGTH-1:0]e_next;
	wire [NUM_WIDTH_LENGTH-1:0] out_mul;
	
	Multiply Multiply ( .in1(hq), .in2(c1), .out(out_mul));
	Carryselectadder Carryselectadder ( .in1(e), .in2(out_mul), .cin(1'b0) ,.out(e_next));
	
endmodule

module Multiply ( in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1] out;
	
	wire [13:1] temp [13:1];
	wire [13:1] temp_2 [6:1];
	wire [13:1] temp_3 [3:1];
	wire [13:1] temp_4 [2:1];
	
	And_row_1 And_row_1 ( .in1(in1), .in2(in2), .out(temp[1]) );
	And_row_2 And_row_2 ( .in1(in1), .in2(in2), .out(temp[2]) );
	And_row_3 And_row_3 ( .in1(in1), .in2(in2), .out(temp[3]) );
	And_row_4 And_row_4 ( .in1(in1), .in2(in2), .out(temp[4]) );
	And_row_5 And_row_5 ( .in1(in1), .in2(in2), .out(temp[5]) );
	And_row_6 And_row_6 ( .in1(in1), .in2(in2), .out(temp[6]) );
	And_row_7 And_row_7 ( .in1(in1), .in2(in2), .out(temp[7]) );
	And_row_8 And_row_8 ( .in1(in1), .in2(in2), .out(temp[8]) );
	And_row_9 And_row_9 ( .in1(in1), .in2(in2), .out(temp[9]) );
	And_row_10 And_row_10 ( .in1(in1), .in2(in2), .out(temp[10]) );
	And_row_11 And_row_11 ( .in1(in1), .in2(in2), .out(temp[11]) );
	And_row_12 And_row_12 ( .in1(in1), .in2(in2), .out(temp[12]) );
	And_row_13 And_row_13 ( .in1(in1), .in2(in2), .out(temp[13]) );

	genvar i;
	generate
		for (i=1; i<=11; i=i+2) begin
			Carryselectadder Carryselectadder ( .in1(temp[i]), .in2(temp[i+1]), .cin(1'b0), .out(temp_2[(i+1)/2]));
		end 
	endgenerate

	generate
		for (i=1; i<=5; i=i+2) begin
			Carryselectadder Carryselectadder_2 ( .in1(temp_2[i]), .in2(temp_2[i+1]), .cin(1'b0), .out(temp_3[(i+1)/2]));
		end 
	endgenerate
	
	Carryselectadder Carryselectadder_3 ( .in1(temp_3[1]), .in2(temp_3[2]), .cin(1'b0), .out(temp_4[1]));
	Carryselectadder Carryselectadder_4 ( .in1(temp_3[3]), .in2(temp[13]), .cin(1'b0), .out(temp_4[2]));
	Carryselectadder Carryselectadder_5 ( .in1(temp_4[1]), .in2(temp_4[2]), .cin(1'b0), .out(out));
	
endmodule


module And_row_1 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=1; i<=13; i=i+1) begin
			assign out[i] = in1[i]&in2[1];
		end
	endgenerate
endmodule
module And_row_2 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=2; i<=13; i=i+1) begin
			assign out[i] = in1[i-1]&in2[2];
		end
	endgenerate
	assign out[1]=1'd0;
endmodule
module And_row_3 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=3; i<=13; i=i+1) begin
			assign out[i] = in1[i-2]&in2[3];
		end
	endgenerate
	assign out[2:1]=2'd0;
endmodule
module And_row_4 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=4; i<=13; i=i+1) begin
			assign out[i] = in1[i-3]&in2[4];
		end
	endgenerate
	assign out[3:1]=3'd0;
endmodule

module And_row_5 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=5; i<=13; i=i+1) begin
			assign out[i] = in1[i-4]&in2[5];
		end
	endgenerate
	assign out[4:1]=4'd0;
endmodule

module And_row_6 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=6; i<=13; i=i+1) begin
			assign out[i] = in1[i-5]&in2[6];
		end
	endgenerate
	assign out[5:1]=5'd0;
endmodule

module And_row_7 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=7; i<=13; i=i+1) begin
			assign out[i] = in1[i-6]&in2[7];
		end
	endgenerate
	assign out[6:1]=6'd0;
endmodule

module And_row_8 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=8; i<=13; i=i+1) begin
			assign out[i] = in1[i-7]&in2[8];
		end
	endgenerate
	assign out[7:1]=7'd0;
endmodule

module And_row_9 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=9; i<=13; i=i+1) begin
			assign out[i] = in1[i-8]&in2[9];
		end
	endgenerate
	assign out[8:1]=8'd0;
endmodule

module And_row_10 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=10; i<=13; i=i+1) begin
			assign out[i] = in1[i-9]&in2[10];
		end
	endgenerate
	assign out[9:1]=9'd0;
endmodule

module And_row_11 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=11; i<=13; i=i+1) begin
			assign out[i] = in1[i-10]&in2[11];
		end
	endgenerate
	assign out[10:1]=10'd0;
endmodule

module And_row_12 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	genvar i;
	generate 
		for (i=12; i<=13; i=i+1) begin
			assign out[i] = in1[i-11]&in2[12];
		end
	endgenerate
	assign out[11:1]=11'd0;
endmodule

module And_row_13 (in1, in2, out);
	input wire [13:1] in1, in2;
	output wire [13:1]out;
	assign out[13] = in1[1] & in2[13];  
	assign out[12:1]=12'd0;
endmodule

module Carryselectadder ( in1, in2, cin ,out);
	parameter NUM_WIDTH_LENGTH=13;
	input wire [NUM_WIDTH_LENGTH-1:0] in1,in2;
	input wire cin;
	output wire [NUM_WIDTH_LENGTH-1:0] out;

	wire [7:0]cout_1,cout_2,cout;
	wire [3:0]out_1[0:7];
	wire [3:0]out_2[0:7];
	adder4bit entity (.in1(in1[3:0]), .in2(in2[3:0]), .cin(cin), .out(out[3:0]), .cout(cout[0]));
	genvar i;
	generate	
		for (i=1;i<3;i=i+1) begin
			adder4bit entity_1 (.in1(in1[i*4+3:i*4]), .in2(in2[i*4+3:i*4]), .cin(1'd0), .out(out_1[i]), .cout(cout_1[i]));
			adder4bit entity_2 (.in1(in1[i*4+3:i*4]), .in2(in2[i*4+3:i*4]), .cin(1'b1), .out(out_2[i]), .cout(cout_2[i]));
			mux4 entity_3 (.in1(out_1[i]), .in2(out_2[i]), .sel(cout[i-1]), .out(out[i*4+3:i*4]));
			mux2to1 entity_4 (.in1(cout_1[i]), .in2(cout_2[i]), .sel(cout[i-1]), .out(cout[i]));
		end 
	endgenerate
	adder entity_5 (.in1(in1[12]), .in2(in2[12]), .cin(cout[2]), .out(out[12]), .cout(cout[7]));
endmodule

module mux2to1 (in1, in2, sel, out);
	input wire in1,in2,sel;
	output wire out;
	assign out=in1&~sel|in2&sel;
endmodule

module mux4 (in1, in2, sel, out);
	input wire [3:0]in1,in2;
	input wire  sel;
	output wire [3:0] out;
	mux2to1 entity_0 (.in1(in1[0]), .in2(in2[0]), .sel(sel), .out(out[0]));
	mux2to1 entity_1 (.in1(in1[1]), .in2(in2[1]), .sel(sel), .out(out[1]));
	mux2to1 entity_2 (.in1(in1[2]), .in2(in2[2]), .sel(sel), .out(out[2]));
	mux2to1 entity_3 (.in1(in1[3]), .in2(in2[3]), .sel(sel), .out(out[3]));
endmodule

module mux_N (in1, in2, sel, out);
	parameter NUM_WIDTH_LENGTH=13;
	input wire [NUM_WIDTH_LENGTH-1:0] in1, in2;
	input wire sel;
	output wire [NUM_WIDTH_LENGTH-1:0] out;
	assign out=in1&{NUM_WIDTH_LENGTH{~sel}}|in2&{NUM_WIDTH_LENGTH{sel}};
endmodule

module Xor_N_bit ( h, r, out_xor);
	parameter NUM_WIDTH_LENGTH=13;
	input wire[NUM_WIDTH_LENGTH-1:0] h;
	input wire r;
	output wire [NUM_WIDTH_LENGTH-1:0] out_xor;
	assign out_xor=h^{NUM_WIDTH_LENGTH{r}};
endmodule

module Regfile (in1, clk, out,rst);
	parameter NUM_WIDTH_LENGTH=13;
	input wire [NUM_WIDTH_LENGTH-1:0] in1;
	input wire clk;
	input logic rst;
	output reg [NUM_WIDTH_LENGTH-1:0] out;

	always @(negedge clk) begin
		if (rst==0)
			out<=in1;
		else
			out<=0;
	end
endmodule


module adder (in1, in2, cin, out, cout);
	input wire in1, in2, cin;
	output reg out, cout;
	always@* begin
		 out=in1^in2^cin;
		 cout=in1&in2|in1&cin|in2&cin;
	end
endmodule

module adder4bit (in1, in2, cin, out, cout);
	input wire [3:0] in1, in2;
	input wire cin;
	output wire [3:0] out;
	output wire cout;
	wire cout_1,cout_2,cout_3;
	adder adder_1 (.in1(in1[0]), .in2(in2[0]), .cin(cin), .out(out[0]), .cout(cout_1));
	adder adder_2 (.in1(in1[1]), .in2(in2[1]), .cin(cout_1), .out(out[1]), .cout(cout_2));
	adder adder_3 (.in1(in1[2]), .in2(in2[2]), .cin(cout_2), .out(out[2]), .cout(cout_3));
	adder adder_4 (.in1(in1[3]), .in2(in2[3]), .cin(cout_3), .out(out[3]), .cout(cout));
endmodule