// `include "ter_arith.sv"
`timescale 1ns / 1ps

module poly_lift (clk ,rst, en, m_in, m0);
    parameter M_BITS = 1402, RQ_BITS = 9113, N_SUB_1_DIV_3 = 233, Q_BITS = 13;
    parameter M_INPUT_BITS = 4, NTRU_N = 701;
    input clk, rst, en;
    input [M_INPUT_BITS:1] m_in;
    output [RQ_BITS:1] m0;

    wire [M_INPUT_BITS:1] m;
    wire [M_BITS:1] m1, m2, z;

    assign m = (en) ? m_in : 4'b0;

    inverse_phi1 IV ( .clk(clk), .rst(rst), .z(z) );

    lift_slice HEAD_SLICE ( .clk(clk), .rst(rst),
    .z( { z[2:1], z[M_BITS:M_BITS-1] } ),
    .m(m), .m1( m1[2:1] ) );

    generate
        genvar i;
        for (i = 0; i < NTRU_N-1; i = i + 1)
        begin: CALC_M1

            lift_slice SLICE ( .clk(clk), .rst(rst),
            .z( { z[2*i+4:2*i+1] } ),
            .m(m), .m1( m1[ 2*i+4 : 2*i+3 ] ) );

        end
    endgenerate

    generate
        for (i = 1; i < NTRU_N+1; i = i + 1)
        begin: SUB_LOOP1
            sub_ter SUB_TER ( .x( m1[2*i : 2*i-1] ), .y( m1[M_BITS : M_BITS-1] ),
            .z( m2[2*i : 2*i-1] ) );
        end
    endgenerate

    assign m0[13:1] = { {12{ m2[2] ^ m2[1] }}, m2[1] };

    generate
        for (i = 1; i < NTRU_N; i = i + 1)
        begin: SUB_LOOP2
            sub_2i2_o13 SUB ( .x( m2[2*i : 2*i-1] ), .y( m2[2*i+2 : 2*i+1] ),
            .z( m0[Q_BITS*i+Q_BITS : Q_BITS*i+1] ) );
        end
    endgenerate

endmodule // poly_lift

module lift_slice (clk, rst, z, m, m1);
    input clk, rst;
    input [3:0] z, m;
    output reg [1:0] m1;
    wire [1:0] z1, z2, z3, m_next;

    always @ ( posedge clk ) begin
        if (rst) begin
            m1 <= 0;
        end else begin
            m1 <= m_next;
        end
    end

    mul_ter MUL1 ( .x( m[1:0] ), .y( z[3:2] ), .z(z1) );
    mul_ter MUL2 ( .x( m[3:2] ), .y( z[1:0] ), .z(z2) );

    add_ter ADD1 ( .x( z1 ), .y( z2 ), .z( z3 ) );
    add_ter ADD2 ( .x( m1 ), .y( z3 ), .z( m_next ) );

endmodule // lift_slice
