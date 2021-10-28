`include "ppa_sk.sv"
`include "mux.sv"

module bit8_to_trit5(rst, clk, a, count, out);
    input [9:0] check_holder;
    input [7:0] a;
    input [2:0] count;
    input rst, clk;
    output reg [9:0] out;
    wire [1:0] trit;
    reg [7:0] a_reg;
    wire[7:0] pow3_2, pow3_1, x2, x1, x;

    always @ ( posedge clk ) begin
        if (rst) begin
            #0.3 a_reg <= a;
        end else begin
            #0.3 a_reg <= x;
        end
    end

    gen_pow3 GEN ( .count( count ), .pow3_2( pow3_2 ), .pow3_1( pow3_1 ) );
    sub_2i8_o8 SUB2 ( .x1( a_reg ), .y( pow3_2 ), .out( x2 ), .carry( trit[1] ) );
    sub_2i8_o8 SUB1 ( .x1( a_reg ), .y( pow3_1 ), .out( x1 ), .carry( trit[0] ) );

    mux_4i8_o8 MUX ( .a3( x2 ), .a2( 8'b0 ), .a1( x1 ), .a0( a_reg ), .sel( trit ), .out( x ) );

    sipo SIPO ( .clk( clk ), .init( trit ), .out( out ) );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

endmodule

module sipo (clk, init, out);
    input clk;
    input [1:0] init;
    output reg [9:0] out;

    always @ ( posedge clk) begin
        #0.2 out <= { out[7:0], init};
    end

endmodule // sipo

module gen_pow3 (count, pow3_2, pow3_1);
    input [2:0] count;
    output [7:0] pow3_2, pow3_1;

    assign pow3_2 = { pow3_1[6:0], 1'b0 };
    assign pow3_1[7:4] = { 1'b0, ~|count, 1'b0, ~|count[2:1]};
    assign pow3_1[3:0] = { count[1] ^ count[0], 1'b0, count[0], 1'b1 };

endmodule // gen_pow3
