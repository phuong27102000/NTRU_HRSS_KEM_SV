module carryselectadder ( in1, in2, cin ,out);
	parameter NUM_WIDTH_LENGTH=32;
	input wire [NUM_WIDTH_LENGTH-1:0] in1,in2;
	input cin;
	output wire [NUM_WIDTH_LENGTH-1:0] out;

	wire [7:0]cout_1,cout_2,cout;
	wire [3:0]out_1[0:7];
	wire [3:0]out_2[0:7];
	adder4bit entity (.in1(in1[3:0]), .in2(in2[3:0]), .cin(cin), .out(out[3:0]), .cout(cout[0]));
	genvar i;
	for (i=1;i<8;i=i+1) begin
	adder4bit entity_1 (.in1(in1[i*4+3:i*4]), .in2(in2[i*4+3:i*4]), .cin(1'b0), .out(out_1[i]), .cout(cout_1[i]));
	adder4bit entity_2 (.in1(in1[i*4+3:i*4]), .in2(in2[i*4+3:i*4]), .cin(1'b1), .out(out_2[i]), .cout(cout_2[i]));
	mux4 entity_3 (.in1(out_1[i]), .in2(out_2[i]), .sel(cout[i-1]), .out(out[i*4+3:i*4]));
	mux2to1 entity_4 (.in1(cout_1[i]), .in2(cout_2[i]), .sel(cout[i-1]), .out(cout[i]));
	end 

endmodule

