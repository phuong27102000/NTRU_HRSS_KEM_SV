`include "inc_i8_o8.sv"
module testbench;
  reg [7:0] a;
  wire[7:0] out;
  integer i;
  
  inc_i8_o8 INC (a,out);
  
  initial begin 
    i = 0;
    forever begin
      a = i; #1;
      i = i + 1;
    end
  end
  
  initial begin
    #300;
    $finish;
  end
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule
