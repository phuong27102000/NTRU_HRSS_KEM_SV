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
