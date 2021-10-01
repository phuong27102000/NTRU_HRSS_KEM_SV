`include "inc_i8_o8.sv"
`timescale 1ns/1ps
module inc_tb(input [7:0] a, 
              output [7:0] out);
    
    inc_i8_o8 INC (a,out);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule