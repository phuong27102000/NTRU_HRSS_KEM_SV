`include "mod3_i8_o1.sv"
module testbench;
  reg rst, clk;
  reg[7:0] in;
  wire[1:0] out;
  integer i;
  
  mod3_i8_o1 MOD3 (rst, clk, in, out);
  
  always #1 clk = ~clk;
    
  initial begin
    clk = 0;
    for (i=0; i < 256; i=i+1) begin
      rst = 1;
      in = i; #2;
      rst = 0;#10;
    end
    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule
