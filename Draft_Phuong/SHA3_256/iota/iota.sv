`timescale 1ns/1ps
`include "rc.sv"

module testbench(a, rst, en, b);
    input[1600:1] a;
    input rst, en;
    output[1600:1] b;
    wire[6:0] rc;

    iota IOTA (a, rc, b);
    rc RC (rst, en, rc);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module iota(a, rc, b);
    input[1599:0] a;
    input[6:0] rc;
    output[1599:0] b;

    assign b[1599:64] = a[1599:64];
    assign {b[63], b[31], b[15], b[7], b[3], b[1], b[0]} = {a[63], a[31], a[15], a[7], a[3], a[1], a[0]} ^ rc;

    genvar i;
    generate
        for (i = 4; i <= 64; i = i<<1) begin: loop1
            assign b[i-2 : (i>>1)] = a[i-2 : (i>>1)];
        end
    endgenerate

endmodule
