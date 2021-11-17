`timescale 1ns / 1ps

module bytes_to_bits_h (rst, clk, h_in, h);
    parameter H_LEN_DIV_8 = 1138;

    input rst, clk;
    input [9104:1] h_in;
    output reg [9100:1] h;
    wire [9104:1] h1;

    generate
        genvar i;
        for (i = 0; i < H_LEN_DIV_8; i = i + 1)
        begin: MAP
            assign h1[9104-8*i : 9097-8*i] = h_in[8*i+8 : 8*i+1];
        end
    endgenerate

    always @ ( posedge clk ) begin
        if (rst) begin
            #0.2 h <= h1[9100:1];
        end else begin
            #0.2 h <= {h[26:1],h[9100:27]};
        end
    end

endmodule // bytes_to_bits_h

module bits_to_bytes_k (k_in, k);
    parameter K_LEN_DIV_8 = 32;
    input [256:1] k_in;
    output [256:1] k;

    generate
        genvar i;
        for (i = 0; i < K_LEN_DIV_8; i = i + 1)
        begin: MAP
            assign k[256-8*i:249-8*i] = k_in[8*i+8:8*i+1];
        end
    endgenerate

endmodule // bits_to_bytes_k
