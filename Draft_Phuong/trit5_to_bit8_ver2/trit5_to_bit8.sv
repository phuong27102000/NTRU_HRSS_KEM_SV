`include "ppa_sk.sv"
`include "mux.sv"
`include "inc_i2_o2.sv"

module trit5_to_bit8_tb(rst1, rst2, clk, a, out, x, z, done, x0, x1, x2, x3, x4, a_reg);
    input rst1, rst2, clk;
    input [9:0] a;
    output [9:0] a_reg;
    output reg done;
    output [7:0] out, x, z;
    output[1:0] x0;
    output[2:0] x1;
    output[3:0] x2;
    output[5:0] x3, x4;
    reg[1:0] count;
    wire[1:0] count_new;

    always @(posedge clk)
        if (rst1)
            count <= 3;
        else
            count <= count_new;

    inc_i2_o2 INC ( .a( count ), .out( count_new ) );
    trit5_to_bit8 TRIT2BIT (rst1, rst2, clk, a, out, count, x, z, x0, x1, x2, x3, x4, a_reg);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end
endmodule

module trit5_to_bit8(rst1, rst2, clk, a, out, count, x, z, x0, x1, x2, x3, x4, a_reg);
//transform a 5-trit to an 8-bit
//positive rst
//positive clk
//use external count, positive clk
//rst must be turned off after in taking datas at least 1 period of clk
//after 1 reset period + 4 periods, return the output

    input [9:0] a;
    input [1:0] count;
    input rst1, rst2 ,clk;
    output [9:0] a_reg;
    output [7:0] out, x, z;
    output[1:0] x0;
    output[2:0] x1;
    output[3:0] x2;
    output[5:0] x3, x4;
    wire[1:0] x0;
    wire[2:0] x1;
    wire[3:0] x2;
    wire[5:0] x3, x4;
    wire[7:0] x, z;
    reg [9:0] a_reg;
    reg[7:0] out;

    always @(posedge clk)
        if (rst1) begin
            a_reg <= a;
        end

    always @(posedge clk)
        if (rst2)
            out <= {x4[5:2], 2'b0, x4[1:0]};
        else
            out <= z;

    ppa_sk_i8_o8 ADD ( .x1( x ), .x2( out ), .out( z ) );

    mux_4i8_o1 MUX ( .a3( {2'b0, x3} ), .a2( {3'b0, x2[3:2], 1'b0, x2[1:0]} ), .a1( {5'b0, x1} ), .a0( {6'b0, x0} ), .sel( count ), .out( x ) );

    assign x0 = {a_reg[1] & a_reg[0], a_reg[1] ^ a_reg[0] };
    gen_3_pow4 GEN81 ( .trit( a_reg[9:8] ), .out( x4 ) );
    gen_3_pow3 GEN27 ( .trit( a_reg[7:6] ), .out( x3 ) );
    gen_3_pow2 GEN09 ( .trit( a_reg[5:4] ), .out( x2 ) );
    gen_3_pow1 GEN03 ( .trit( a_reg[3:2] ), .out( x1 ) );

endmodule

module gen_3_pow1(trit, out);
    input [1:0] trit;
    output [2:0] out;

    assign out[0] = trit[0] ^ trit[1];
    assign out[1] = trit[0];
    assign out[2] = trit[1];
endmodule

module gen_3_pow2(trit, out);
    input [1:0] trit;
    output [3:0] out;
//out[3:2] -> out[4:3], 0 -> out[2], out[1:0] -> out[1:0]

    assign out[0] = trit[0] ^ trit[1];
    assign out[1] = trit[1];
    assign out[2] = out[0];
    assign out[3] = out[1];
endmodule

module gen_3_pow3(trit, out);
    input [1:0] trit;
    output [5:0] out;

    assign out[0] = trit[0] ^ trit[1];
    assign out[1] = trit[0];
    assign out[2] = trit[1];
    assign out[3] = out[0];
    assign out[4] = out[1];
    assign out[5] = out[2];
endmodule

module gen_3_pow4(trit, out);
    input [1:0] trit;
    output [5:0] out;
//out[5:2] -> out[7:4], 0 -> out[3:2], out[1:0] -> out[1:0]

    assign out[0] = trit[0] ^ trit[1];
    assign out[1] = trit[1];
    assign out[2] = out[0];
    assign out[3] = out[1];
    assign out[4] = out[0];
    assign out[5] = out[1];
endmodule
