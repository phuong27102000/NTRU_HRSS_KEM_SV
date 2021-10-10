`timescale 1ns/1ps
module testbench(a, out);
    input[1600:1] a;
    output[1600:1] out;

    chi chi (a, out);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module chi(a, out);
    input[1599:0] a;
    output[1599:0] out;

    genvar x,y;
    generate
        for (x = 0; x < 5; x = x+1) begin: loop1
            for (y = 0; y < 1600; y = y+320) begin: loop2
                assign out[y+ 64*x + 63 : y + 64*x] = a[y + 64*x + 63 : y + 64*x] ^ ( (~a[y + 64*((x+1)%5) + 63 : y + 64*((x+1)%5)]) & a[y + 64*((x+2)%5) + 63 : y+ 64*((x+2)%5)] );
            end
        end
    endgenerate
endmodule
