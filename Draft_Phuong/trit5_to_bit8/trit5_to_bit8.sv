`include "ppa_sk.sv"
`include "mux.sv"

module trit5_to_bit8(rst, clk, a, out, count, x, z);
//transform a 5-trit to an 8-bit
//positive rst
//negtive clk
//use external count, positive clk
//after 4 periods, return the output
//rst must be positive at least only half a period (recommend a period) to reset the instantiation
    input [9:0] a;
    input [1:0] count;
    input rst,clk;
    output [7:0] out, x, z;
    reg [6:0] _3_pow_1,  _3_pow_2, _3_pow_3, _3_pow_4;
    wire[7:0] x1, x2, x3, x4, x, z;
    reg[7:0] y0, y1, y2, y3, out;
    
    always @(posedge clk)
        if (rst) begin
            _3_pow_1 <= 3;
            _3_pow_2 <= 9; 
            _3_pow_3 <= 27; 
            _3_pow_4 <= 81;
        end
    always @(negedge clk)
        if (rst) begin
            y0 <= {a[1] & a[0], a[1] ^ a[0] };
            y1 <= x1;
            y2 <= x2;
            y3 <= x3;
            out <= x4;
        end
        else
            out <= z;
            
    ppa_sk_i8_o8 ADD ( .x1( x ), .x2( out ), .out( z ) );
    
    mux_4i8_o1 MUX ( .a3( y3 ), .a2( y2 ), .a1( y1 ), .a0( y0 ), .sel( count ), .out( x ) );
    
    mul_trit REG1 ( .trit( a[9:8] ), .a( _3_pow_4 ), .out( x4 ) );
    mul_trit REG2 ( .trit( a[7:6] ), .a( _3_pow_3 ), .out( x3 ) );
    mul_trit REG3 ( .trit( a[5:4] ), .a( _3_pow_2 ), .out( x2 ) );
    mul_trit REG4 ( .trit( a[3:2] ), .a( _3_pow_1 ), .out( x1 ) );
    
endmodule
        
module mul_trit (trit, a, out);
    input[6:0] a;
    input[1:0] trit;
    output[7:0] out;
    
    mux_4i8_o1 MUX ( .a3( {a,1'b0} ), .a2( 8'b0 ), .a1( {1'b0,a} ), .a0( 8'b0 ), .sel( trit ), .out( out ) );
    
endmodule
