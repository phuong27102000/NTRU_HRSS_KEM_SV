`timescale 1ns / 1ps

module inc_i9_o9(a, out);
//Sklansky AND-prefix structure
    input[8:0] a;
    output[8:0] out;
    wire[11:0] b;

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
    assign b[11] = b[10]&a[7];

    assign out[0] = ~a[0];
    assign out[1] = a[1]^a[0];
    assign out[2] = a[2]^b[3];
    assign out[3] = a[3]^b[4];
    assign out[4] = a[4]^b[7];
    assign out[5] = a[5]^b[8];
    assign out[6] = a[6]^b[9];
    assign out[7] = a[7]^b[10];
    assign out[8] = a[8]^b[11];

endmodule // inc_i9_o9

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

endmodule // inc_i8_o8

module inc_i7_o7 (x, out);
    input [6:0] x;
    output [6:0] out;
    wire [9:0] b;

    assign b[0] = x[1] & x[2];
    assign b[1] = x[3] & x[4];
    assign b[2] = x[5] & x[6];
    assign b[3] = x[0] & x[1];
    assign b[4] = x[0] & b[0];
    assign b[5] = x[5] & b[1];
    assign b[6] = b[2] & b[1];
    assign b[7] = x[3] & b[4];
    assign b[8] = b[1] & b[4];
    assign b[9] = b[4] & b[5];

    assign #0.1 out[0] = ~x[0];
    assign #0.1 out[1] = x[1] ^ x[0];
    assign #0.1 out[2] = x[2] ^ b[3];
    assign #0.1 out[3] = x[3] ^ b[4];
    assign #0.1 out[4] = x[4] ^ b[7];
    assign #0.1 out[5] = x[5] ^ b[8];
    assign #0.1 out[6] = x[6] ^ b[9];

endmodule // inc_i7_o7

module inc_i2_i3 (x, out);
    input [1:0] x;
    output [2:0] out;

    assign #0.1 out[0] = ~x[0];
    assign #0.1 out[1] = x[1] ^ x[0];
    assign #0.1 out[2] = x[1] & x[0];

endmodule // inc_i2_i3
