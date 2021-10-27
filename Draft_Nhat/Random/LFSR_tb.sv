module LFSR_tb;
logic clk;
logic rst;
logic [256:1] coins;
LFSR LFSR (.clk(clk),.rst(rst),.coins(coins));
always begin
	clk=0;
	forever #20 clk=~clk;
	end
initial begin
rst=1;
#60
rst=0;
end
endmodule
