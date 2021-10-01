`include "ternary.sv"
`timescale 1ns/1ps
module ternary_tb(input [5600:1] bit_str,
                  input clk,
                  input rst,
                  output [1400:1] out);
    ternary TNR (bit_str, clk, rst, out);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
