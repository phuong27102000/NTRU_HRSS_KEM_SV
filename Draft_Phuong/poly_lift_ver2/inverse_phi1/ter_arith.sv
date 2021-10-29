module add_ter (x, y, z);
    input [1:0] x,y;
    output [1:0] z;

    assign z[1] = ( x[1] ^ y[0] ) & ( x[0] ^ y[1] );
    assign z[0] = (x[0] ^ y[0]) | (x[1]&y[1]) | ( (~(x[1]|y[1])) & y[0] );

endmodule // add_ter

module mul_ter (x, y, z);
    input [1:0] x,y;
    output [1:0] z;

    assign z[1] = (x[1] & (~y[1]) & y[0]) | ((~x[1]) & y[1] & x[0]);
    assign z[0] = x[0] ^ y[0];

endmodule // mul_ter

module inverse_phi1 (clk, rst, spe_case, init, prev_state, state);
    input clk, rst;
    input [1:0] spe_case;
    input [3:0] init;
    output reg [1:0] state, prev_state;
    wire [1:0] next_state, next2_state;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

    always @ ( posedge clk ) begin
        if (rst) begin
            #0.2 state <= init[3:2];
        end else begin
            #0.2 state <= next2_state;
        end
    end

    always @ ( posedge clk ) begin
        if (rst) begin
            #0.2 prev_state <= init[1:0];
        end else begin
            #0.2 prev_state <= next_state;
        end
    end

    inverse_phi1_next_state NEXT1 ( .spe_case( spe_case[1] ), .state( state ),
    .next_state( next_state ) );
    inverse_phi1_next_state NEXT2 ( .spe_case( spe_case[0] ), .state( next_state ),
    .next_state( next2_state ) );

endmodule // inverse_phi

module inverse_phi1_next_state(spe_case, state, next_state);
    input spe_case;
    input [1:0] state;
    output [1:0] next_state;

    assign next_state[1] = ~(spe_case | state[1]) & state[0];
    assign next_state[0] = ~(spe_case | state[1]) | ( ~state[0] );
endmodule // inverse_phi
