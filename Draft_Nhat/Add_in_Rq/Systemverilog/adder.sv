module adder (in1, in2, cin, out, cout);
	input wire in1, in2, cin;
	output reg out, cout;
	always@* begin
	 out=in1^in2^cin;
	 cout=in1&in2|in1&cin|in2&cin;
	end
endmodule
