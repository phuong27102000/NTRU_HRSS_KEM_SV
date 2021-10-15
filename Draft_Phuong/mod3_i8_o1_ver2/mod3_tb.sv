`include "mod3_i8_o1.sv"
module mod3_tb(input [7:0] in_sig, 
               output [1:0] out_sig);
    
    mod3_i8_o1 MOD3 (in_sig, out_sig);
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule
