`include "pack_s3.sv"

module pack_s3_tb(rst, clk, a, out, work, now);
    input [1400:1] a;
    input rst, clk;
    output [1120:1] out;
    output work;
    output [2:0] now;
    
    pack_s3 PACK (rst, clk, a, out, work, now);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule