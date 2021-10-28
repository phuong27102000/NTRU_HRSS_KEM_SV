`include "ter_arith.sv"
module poly_lift (clk ,rst, m, m0);
    parameter M_BITS = 1402, RQ_BITS = 9113, N_SUB_1_DIV_3 = 233, Q_BITS = 13;
    parameter M_INPUT_BITS = 4, NTRU_N = 701;
    input clk, rst;
    input [M_INPUT_BITS:1] m;
    input [M_BITS:1] m1;
    output [RQ_BITS:1] m0;

    reg [NTRU_N:1] spe_case;
    wire [2804:1] st;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

    lift_slice HEAD_SLICE ( .clk(clk), .rst(rst),
    .spe_case(2'b00), .init(4'b0001),
    .m(m), .m1( m1[2:1] ), .st( st[4:1] ) );

    generate
        genvar i;
        for (i = 0; i < N_SUB_1_DIV_3; i = i + 1)
        begin: CALC_M1

            lift_slice SLICE1 ( .clk(clk), .rst(rst),
            .spe_case(spe_case[3*i+3 : 3*i+2]), .init(4'b0100),
            .m(m), .m1( m1[ 6*i+4 : 6*i+3 ] ), .st( st[12*i+8:12*i+5] ) );

            lift_slice SLICE2 ( .clk(clk), .rst(rst),
            .spe_case(spe_case[3*i+4 : 3*i+3]), .init(4'b0011),
            .m(m), .m1( m1[ 6*i+6 : 6*i+5 ] ), .st( st[12*i+12:12*i+9] ) );

            lift_slice SLICE0 ( .clk(clk), .rst(rst),
            .spe_case(spe_case[3*i+5 : 3*i+4]), .init(4'b1101),
            .m(m), .m1( m1[ 6*i+8 : 6*i+7 ] ), .st( st[12*i+16:12*i+13] ) );

        end
    endgenerate

    lift_slice TAIL_SLICE ( .clk(clk), .rst(rst),
    .spe_case( {1'b0,spe_case[NTRU_N]} ), .init(4'b0100),
    .m(m), .m1( m1[ 1402 : 1401 ] ), .st( st[2804:2801] ) );

    always @ ( posedge clk ) begin
        if (rst) begin
            spe_case <= 4;
        end else begin
            #0.2 spe_case <= { spe_case[NTRU_N-2:1], 2'b00 };
        end
    end

    assign m0[13:1] = { {12{ m1[1] ^ m1[0] }}, m1[0] };

    generate
        for (i = 1; i < NTRU_N; i = i + 1)
        begin: SUB_LOOP
            sub_2i2_o13 SUB ( .x( m1[2*i : 2*i-1] ), .y( m1[2*i+2 : 2*i+1] ),
            .z( m0[Q_BITS*i+Q_BITS : Q_BITS*i+1] ) );
        end
    endgenerate


endmodule // poly_lift

module lift_slice (clk, rst, spe_case, init, m, m1, st);
    input clk, rst;
    input[1:0] spe_case;
    input [3:0] init;
    input [3:0] m;
    output reg [1:0] m1;
    output[3:0] st;
    wire [1:0] state, prev_state, m_next, z1, z2, z;

    always @ ( posedge clk ) begin
        if (rst) begin
            m1 <= 0;
        end else begin
            m1 <= m_next;
        end
    end

    inverse_phi1 IV ( .clk(clk), .rst(rst), .spe_case(spe_case), .init(init),
    .prev_state(prev_state), .state(state));

    mul_ter MUL1 ( .x( m[1:0] ), .y( prev_state ), .z(z1) );
    mul_ter MUL2 ( .x( m[3:2] ), .y( state ), .z(z2) );

    add_ter ADD1 ( .x( z1 ), .y( z2 ), .z( z ) );
    add_ter ADD2 ( .x( m1 ), .y( z ), .z( m_next ) );

    assign st = {state, prev_state};

endmodule // lift_slice

module sub_2i2_o13 (x, y, z);
    input [1:0] x;
    input [1:0] y;
    output [12:0] z;

    assign z[0] = x[0] ^ y[0];
    assign z[1] = ( x[1] & (~y[1]) ) | ( (~x[0]) & (~y[1]) & y[0] )
    | ((~x[1]) & x[0] & y[1]);
    assign z[2] = ( x[1] & (~y[1]) ) | ( (~x[0]) & (~y[1]) & y[0] );
    assign z[12:3] = {10{z[2]}};

endmodule // sub_2i2_o3
