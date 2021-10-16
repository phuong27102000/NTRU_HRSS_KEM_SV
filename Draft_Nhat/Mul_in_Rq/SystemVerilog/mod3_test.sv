module mod3_test;
reg clk;
reg [31:0] in;
wire [1:0] out;
always begin 
in=32'h12345678;
clk=0;
forever #20 clk=~clk;
end

mod3 mod3 (.in(in), .clk(clk), .out(out));
endmodule
