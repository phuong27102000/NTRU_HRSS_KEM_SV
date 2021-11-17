`timescale 1ns / 1ps

module mux_4i8_o1(a3, a2, a1, a0, sel, out);
    input[7:0] a0, a1, a2, a3;
    input[1:0] sel;
    output[7:0] out;
    
    mux_i4_o1 MUX0 ( { a3[0], a2[0], a1[0], a0[0] }, sel, out[0] );
    mux_i4_o1 MUX1 ( { a3[1], a2[1], a1[1], a0[1] }, sel, out[1] );
    mux_i4_o1 MUX2 ( { a3[2], a2[2], a1[2], a0[2] }, sel, out[2] );
    mux_i4_o1 MUX3 ( { a3[3], a2[3], a1[3], a0[3] }, sel, out[3] );
    mux_i4_o1 MUX4 ( { a3[4], a2[4], a1[4], a0[4] }, sel, out[4] );
    mux_i4_o1 MUX5 ( { a3[5], a2[5], a1[5], a0[5] }, sel, out[5] );
    mux_i4_o1 MUX6 ( { a3[6], a2[6], a1[6], a0[6] }, sel, out[6] );
    mux_i4_o1 MUX7 ( { a3[7], a2[7], a1[7], a0[7] }, sel, out[7] );
    
endmodule    

module mux_i4_o1(a, sel, out);
    input[3:0] a;
    input[1:0] sel;
    output out;
    wire b1,b2;
    
    mux_i2_o1 entity_0 ( .in( { a[1], a[0] } ), .sel( sel[0] ), .out( b1 ) );
    mux_i2_o1 entity_1 ( .in( { a[3], a[2] } ), .sel( sel[0] ), .out( b2 ) );
    mux_i2_o1 entity_2 ( .in( { b2, b1 } ), .sel( sel[1] ), .out(out) );
endmodule

module mux_i2_o1 (in, sel, out);
    input [2:1] in;
	input sel;
	output out;
    assign out = ( in[1] & (~sel) ) | ( in[2] & sel );
endmodule
