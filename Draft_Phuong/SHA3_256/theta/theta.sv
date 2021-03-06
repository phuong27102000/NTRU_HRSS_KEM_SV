`timescale 1ns/1ps
module testbench(a, out);
    input[1600:1] a;
    output[1600:1] out;
    output[320:1] c,d;

    theta THETA (a, c, d, out);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module theta(a, c, d, out);
    input[1600:1] a;
    output[1600:1] out;
    output[320:1] c,d;

    theta_step1 STEP1 ( .a(a), .c(c) );
    theta_step2 STEP2 ( .c(c), .d(d) );
    theta_step3 STEP3 ( .a(a), .d(d), .out(out) );

endmodule

module theta_step1(a, c);
    input[1599:0] a;
    output[319:0] c;

    genvar i;
    generate
        for (i = 0; i < 320; i = i+1) begin: loop1
            assign c[i] = a[i] ^ a[i + 320] ^ a[i + 640] ^ a[i + 960] ^ a[i + 1280];
        end
    endgenerate
endmodule

module theta_step2(c, d);
    input[319:0] c;
    output[319:0] d;

    genvar x, z;
    generate
        for (x = 0; x < 5; x = x+1) begin: loop1
            for (z = 0; z < 64; z = z+1)  begin: loop2
                assign d[64*x+z] = c[ 64*( (x+4)%5 ) + z ] ^ c[ 64*( (x+1)%5 ) + ( (z+63)%64 ) ];
            end
        end
    endgenerate
endmodule

module theta_step3(a, d, out);
    input[1599:0] a;
    input[319:0] d;
    output[1599:0] out;

    assign out[319:0] = a[319:0] ^ d[319:0];
    assign out[639:320] = a[639:320] ^ d[319:0];
    assign out[959:640] = a[959:640] ^ d[319:0];
    assign out[1279:960] = a[1279:960] ^ d[319:0];
    assign out[1599:1280] = a[1599:1280] ^ d[319:0];
    
endmodule
