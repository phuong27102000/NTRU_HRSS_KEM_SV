`include "ppa_sk.sv"
`include "mux.sv"

module trit5_to_bit8(rst, clk, a, out, count, x, z);
//transform a 5-trit to an 8-bit
//positive rst
//positive clk
//use external count, positive clk
//rst must be turned off after in taking datas at least 1 period of clk
//after 1 reset period + 4 periods, return the output
    
    input [9:0] a;
    input [1:0] count;
    input rst,clk;
    output [7:0] out, x, z;
    reg [6:0] _3_pow_1,  _3_pow_2, _3_pow_3, _3_pow_4;
    wire[7:0] x0, x1, x2, x3, x4, x, z;
    reg [9:0] a_reg;
    reg[7:0] out;
    
    always @(posedge clk)
        if (rst) begin
            _3_pow_1 <= 3;
            _3_pow_2 <= 9; 
            _3_pow_3 <= 27; 
            _3_pow_4 <= 81;
            a_reg <= a;
        end
    always @(negedge clk)
        if (rst)
            out <= x4;
        else
            out <= z;
            
    ppa_sk_i8_o8 ADD ( .x1( x ), .x2( out ), .out( z ) );
    
    mux_4i8_o1 MUX ( .a3( x3 ), .a2( x2 ), .a1( x1 ), .a0( x0 ), .sel( count ), .out( x ) );
    
    assign x0 = {a_reg[1] & a_reg[0], a_reg[1] ^ a_reg[0] };
    mul_trit REG1 ( .trit( a_reg[9:8] ), .a( _3_pow_4 ), .out( x4 ) );
    mul_trit REG2 ( .trit( a_reg[7:6] ), .a( _3_pow_3 ), .out( x3 ) );
    mul_trit REG3 ( .trit( a_reg[5:4] ), .a( _3_pow_2 ), .out( x2 ) );
    mul_trit REG4 ( .trit( a_reg[3:2] ), .a( _3_pow_1 ), .out( x1 ) );
    
endmodule
        
module mul_trit (trit, a, out);
    input[6:0] a;
    input[1:0] trit;
    output[7:0] out;
    
    mux_4i8_o1 MUX ( .a3( {a,1'b0} ), .a2( 8'b0 ), .a1( {1'b0,a} ), .a0( 8'b0 ), .sel( trit ), .out( out ) );
    
endmodule
