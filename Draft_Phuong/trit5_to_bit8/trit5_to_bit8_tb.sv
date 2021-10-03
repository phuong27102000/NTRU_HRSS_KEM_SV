`include "trit5_to_bit8.sv"
`include "inc_i2_o2.sv"
module trit5_to_bit8_tb(rst, clk, a, out, x, z, done);
    input rst, clk;
    input [9:0] a;
    output done;
    output [7:0] out, x, z;
    reg[1:0] count;
    wire[1:0] count_new;
    reg done;
    
    always @(posedge clk) begin
        if ( rst&(~done) )
            count <= 0;
        else
            count <= count_new;
    end
    
    
    always @(negedge clk) begin
        if (rst)
            done <= 0;
        else if (count == 3)
            done <= 1;
    end
        
    
    inc_i2_o2 INC ( .a( count ), .out( count_new ) );
    trit5_to_bit8 TRIT2BIT (rst, clk, a, out, count, x, z);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
