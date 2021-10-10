`timescale 1ns/1ps
module testbench(a, out);
    input[1600:1] a;
    output[1600:1] out;

    pi pi (a, out);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module pi(a, out);
    input[1599:0] a;
    output[1599:0] out;

    genvar x,y;
    generate
        for (x = 0; x < 5; x = x+1) begin: loop1
            for (y = 0; y < 5; y = y+1) begin: loop2
                assign out[320*y + 64*x + 63 : 320*y + 64*x] = a[320*x + 64*( (x+3*y)%5 ) + 63 : 320*x + 64*( (x+3*y)%5 )];
            end
        end
    endgenerate
endmodule
