`timescale 1ns/1ps
module testbench(a, out);
    input[1600:1] a;
    output[1600:1] out;

    rho RHO (a, out);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
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
