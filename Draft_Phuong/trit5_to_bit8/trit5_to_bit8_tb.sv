`include "trit5_to_bit8.sv"
`include "inc_i2_o2.sv"
module trit5_to_bit8_tb(rst, clk, a, out, x, z, done);
    input rst, clk;
    input [9:0] a;
    output reg done;
    output [7:0] out, x, z;
    reg[1:0] count;
    wire[1:0] count_new;
    
    always @(posedge clk)
        if (rst)
            count <= 3;
        else
            count <= count_new;
    
    always @(negedge clk)
        done <= (~rst) & (&count);
    
    inc_i2_o2 INC ( .a( count ), .out( count_new ) );
    trit5_to_bit8 TRIT2BIT (rst, clk, a, out, count, x, z);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
