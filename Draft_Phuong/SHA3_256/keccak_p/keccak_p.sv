module testbench(rst1, rst2, clk, s, out, count);
//count = 24, break;
    input[1600:1] s;
    input rst1, rst2, clk;
    output reg [1600:1] out;
    output reg[7:0] count;
    wire[7:0] count_new;

    keccak_p KECCAK_P (rst1, rst2, clk, s, out);
    inc_i8_o8 INC (count, count_new);

    always @ (posedge clk) begin
        if(rst1)
            count <= 0;
        else
            count <= count_new;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module keccak_p(rst1, rst2, clk, s, out);
//b (len of s) = 1600, nr = 24, w = 64, l = 6
//"en" to change value of rc
    input[1600:1] s;
    input rst1, rst2, clk;
    output reg [1600:1] out;
    wire[1600:1] a, b, c, d, e;
    wire[6:0] rc;

    theta THETA ( .a(out), .out(a) );
    rho RHO ( .a(a), .out(b) );
    pi PI ( .a(b), .out(c) );
    chi CHI ( .a(c), .out(d) );
    rc RC ( .rst (rst1), .en(clk), .out( rc ) );
    iota IOTA ( .a(d), .rc(rc), .b(e) );

    always @ (negedge clk) begin
        if(rst2)
            out <= s;
        else
            out <= e;
    end
endmodule

module theta(a, out);
    input[1600:1] a;
    output[1600:1] out;
    wire[320:1] c,d;

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

    genvar x,y,z;
    generate
        for (x = 0; x < 5; x = x+1) begin: loop1
            for (y = 0; y < 5; y = y+1) begin: loop2
                for (z = 0; z < 64; z = z+1)  begin: loop3
                    assign out[320*y+64*x+z] = a[320*y+64*x+z] ^ d[64*x+z];
                end
            end
        end
    endgenerate
endmodule

module rho(a, out);
    input[1599:0] a;
    output[1599:0] out;

    assign out[63:0] = a[63:0];
    genvar z;
    generate
        //t = 0. 320*y + 64*x,m = 64,1
        for (z = 0; z < 64; z = z+1) begin: loop0
            assign out[64 + z] = a[64 + ( (z - 1) & 63 ) ];
        end

        //t = 1. 320*y + 64*x,m = 640,3
        for (z = 0; z < 64; z = z+1) begin: loop1
            assign out[640 + z] = a[640 + ( (z - 3) & 63 ) ];
        end

        //t = 2. 320*y + 64*x,m = 448,6
        for (z = 0; z < 64; z = z+1) begin: loop2
            assign out[448 + z] = a[448 + ( (z - 6) & 63 ) ];
        end

        //t = 3. 320*y + 64*x,m = 704,10
        for (z = 0; z < 64; z = z+1) begin: loop3
            assign out[704 + z] = a[704 + ( (z - 10) & 63 ) ];
        end

        //t = 4. 320*y + 64*x,m = 1088,15
        for (z = 0; z < 64; z = z+1) begin: loop4
            assign out[1088 + z] = a[1088 + ( (z - 15) & 63 ) ];
        end

        //t = 5. 320*y + 64*x,m = 1152,21
        for (z = 0; z < 64; z = z+1) begin: loop5
            assign out[1152 + z] = a[1152 + ( (z - 21) & 63 ) ];
        end

        //t = 6. 320*y + 64*x,m = 192,28
        for (z = 0; z < 64; z = z+1) begin: loop6
            assign out[192 + z] = a[192 + ( (z - 28) & 63 ) ];
        end

        //t = 7. 320*y + 64*x,m = 320,36
        for (z = 0; z < 64; z = z+1) begin: loop7
            assign out[320 + z] = a[320 + ( (z - 36) & 63 ) ];
        end

        //t = 8. 320*y + 64*x,m = 1024,45
        for (z = 0; z < 64; z = z+1) begin: loop8
            assign out[1024 + z] = a[1024 + ( (z - 45) & 63 ) ];
        end

        //t = 9. 320*y + 64*x,m = 512,55
        for (z = 0; z < 64; z = z+1) begin: loop9
            assign out[512 + z] = a[512 + ( (z - 55) & 63 ) ];
        end

        //t = 10. 320*y + 64*x,m = 1344,66
        for (z = 0; z < 64; z = z+1) begin: loop10
            assign out[1344 + z] = a[1344 + ( (z - 66) & 63 ) ];
        end

        //t = 11. 320*y + 64*x,m = 1536,78
        for (z = 0; z < 64; z = z+1) begin: loop11
            assign out[1536 + z] = a[1536 + ( (z - 78) & 63 ) ];
        end

        //t = 12. 320*y + 64*x,m = 256,91
        for (z = 0; z < 64; z = z+1) begin: loop12
            assign out[256 + z] = a[256 + ( (z - 91) & 63 ) ];
        end

        //t = 13. 320*y + 64*x,m = 960,105
        for (z = 0; z < 64; z = z+1) begin: loop13
            assign out[960 + z] = a[960 + ( (z - 105) & 63 ) ];
        end

        //t = 14. 320*y + 64*x,m = 1472,120
        for (z = 0; z < 64; z = z+1) begin: loop14
            assign out[1472 + z] = a[1472 + ( (z - 120) & 63 ) ];
        end

        //t = 15. 320*y + 64*x,m = 1216,136
        for (z = 0; z < 64; z = z+1) begin: loop15
            assign out[1216 + z] = a[1216 + ( (z - 136) & 63 ) ];
        end

        //t = 16. 320*y + 64*x,m = 832,153
        for (z = 0; z < 64; z = z+1) begin: loop16
            assign out[832 + z] = a[832 + ( (z - 153) & 63 ) ];
        end

        //t = 17. 320*y + 64*x,m = 768,171
        for (z = 0; z < 64; z = z+1) begin: loop17
            assign out[768 + z] = a[768 + ( (z - 171) & 63 ) ];
        end

        //t = 18. 320*y + 64*x,m = 128,190
        for (z = 0; z < 64; z = z+1) begin: loop18
            assign out[128 + z] = a[128 + ( (z - 190) & 63 ) ];
        end

        //t = 19. 320*y + 64*x,m = 1280,210
        for (z = 0; z < 64; z = z+1) begin: loop19
            assign out[1280 + z] = a[1280 + ( (z - 210) & 63 ) ];
        end

        //t = 20. 320*y + 64*x,m = 896,231
        for (z = 0; z < 64; z = z+1) begin: loop20
            assign out[896 + z] = a[896 + ( (z - 231) & 63 ) ];
        end

        //t = 21. 320*y + 64*x,m = 1408,253
        for (z = 0; z < 64; z = z+1) begin: loop21
            assign out[1408 + z] = a[1408 + ( (z - 253) & 63 ) ];
        end

        //t = 22. 320*y + 64*x,m = 576,276
        for (z = 0; z < 64; z = z+1) begin: loop22
            assign out[576 + z] = a[576 + ( (z - 276) & 63 ) ];
        end

        //t = 23. 320*y + 64*x,m = 384,300
        for (z = 0; z < 64; z = z+1) begin: loop23
            assign out[384 + z] = a[384 + ( (z - 300) & 63 ) ];
        end
    endgenerate
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

module rc(rst, en, out);
//include rc(0), rc(1), rc(2), rc(3), rc(4), rc(5), rc(6)
//when "en" rises, if "rst" = 0, this module releases new rc.
    input rst, en;
    output [6:0] out;
    wire [56:1] r;
    reg [56:1] a;

    always @ (posedge en) begin
        if (rst) begin   //rc_init
            a[8:1] <= 8'b1;
            a[16:9] <= 8'b10;
            a[24:17] <= 8'b100;
            a[32:25] <= 8'b1000;
            a[40:33] <= 8'b10000;
            a[48:41] <= 8'b100000;
            a[56:49] <= 8'b1000000;
        end
        else
            a <= r;
    end

    assign out = {a[49], a[41], a[33], a[25], a[17], a[9], a[1]};
    rc_7 RC1 ( .a( a[8:1] ) , .b( r[8:1] ) );
    rc_7 RC2 ( .a( a[16:9] ) , .b( r[16:9] ) );
    rc_7 RC3 ( .a( a[24:17] ) , .b( r[24:17] ) );
    rc_7 RC4 ( .a( a[32:25] ) , .b( r[32:25] ) );
    rc_7 RC5 ( .a( a[40:33] ) , .b( r[40:33] ) );
    rc_7 RC6 ( .a( a[48:41] ) , .b( r[48:41] ) );
    rc_7 RC7 ( .a( a[56:49] ) , .b( r[56:49] ) );
endmodule

module rc_7(a, b);
    input [7:0] a;
    output [7:0] b;

    assign b = { a[0]^a[7]^a[3]^a[2], a[7]^a[6]^a[2]^a[1], a[6]^a[2]^a[5]^a[1]^a[3], a[5]^a[7]^a[1]^a[4]^a[3], a[4]^a[7]^a[6], a[3]^a[6]^a[5], a[2]^a[5]^a[4], a[1]^a[4]^a[3] };
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

module inc_i8_o8(a, out);
//Sklansky AND-prefix structure
    input[7:0] a;
    output[7:0] out;
    wire[10:0] b;

    assign b[0] = a[1]&a[2];
    assign b[1] = a[3]&a[4];
    assign b[2] = a[5]&a[6];
    assign b[3] = a[0]&a[1];
    assign b[4] = a[0]&b[0];
    assign b[5] = a[5]&b[1];
    assign b[6] = b[2]&b[1];
    assign b[7] = a[3]&b[4];
    assign b[8] = b[1]&b[4];
    assign b[9] = b[4]&b[5];
    assign b[10] = b[4]&b[6];
    assign out[0] = ~a[0];
    assign out[1] = a[1]^a[0];
    assign out[2] = a[2]^b[3];
    assign out[3] = a[3]^b[4];
    assign out[4] = a[4]^b[7];
    assign out[5] = a[5]^b[8];
    assign out[6] = a[6]^b[9];
    assign out[7] = a[7]^b[10];

endmodule
