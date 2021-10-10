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
