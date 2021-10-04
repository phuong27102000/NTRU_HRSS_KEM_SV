`include "pack_s3.sv"

module pack_s3_tb(rst, clk, a, out);
    input [1400:1] a;
    input rst, clk;
    output [1120:1] out;
    
    pack_s3 PACK (rst, clk, a, out);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule