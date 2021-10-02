`include "ternary.sv"
`timescale 1ns/1ps
module ternary_tb(input [5600:1] bit_str,
                  input clk,
                  input rst,
                  output [1400:1] out,
                  output [2:0] now,
                  output mod3,
                  output [7:0] v);
    ternary TNR (bit_str, clk, rst, out, now, mod3, v);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule