`include "ppa_sk.sv"
module add (x1, x2, out);
    input [7:0] x1;
    input [7:0] x2;
    output [7:0] out;
    ppa_sk_i8_o8 ADD (x1, x2, out);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
    