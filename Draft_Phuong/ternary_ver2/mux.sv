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