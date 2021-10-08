`include "mod3_i8_o1.sv"
`timescale 1ns/1ps
module mod3_tb(input [7:0] in_sig,
               input rst,
               input clk, 
               output [1:0] out_sig);
    
    mod3_i8_o1 MOD3 (rst, clk, in_sig, out_sig);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
