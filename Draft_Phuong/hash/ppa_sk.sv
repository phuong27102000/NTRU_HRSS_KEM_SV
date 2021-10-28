module ppa_sk_i8_o8(x1, x2, out);
    input[7:0] x1;
    input[7:0] x2;
    output[7:0] out;
    wire[7:0] g1,p1;
    wire[3:0] g2,g3,g4;
    wire[3:1] p2;
    wire[3:2] p3;
    
    ha HA1 ( .a( x1[0] ), .b( x2[0] ), .g( g1[0] ), .p( p1[0] ) );
    ha HA2 ( .a( x1[1] ), .b( x2[1] ), .g( g1[1] ), .p( p1[1] ) );
    ha HA3 ( .a( x1[2] ), .b( x2[2] ), .g( g1[2] ), .p( p1[2] ) );
    ha HA4 ( .a( x1[3] ), .b( x2[3] ), .g( g1[3] ), .p( p1[3] ) );
    ha HA5 ( .a( x1[4] ), .b( x2[4] ), .g( g1[4] ), .p( p1[4] ) );
    ha HA6 ( .a( x1[5] ), .b( x2[5] ), .g( g1[5] ), .p( p1[5] ) );
    ha HA7 ( .a( x1[6] ), .b( x2[6] ), .g( g1[6] ), .p( p1[6] ) );
    ha HA8 ( .a( x1[7] ), .b( x2[7] ), .g( g1[7] ), .p( p1[7] ) );

    grey_cell A1 (.gi1( g1[1] ), .pi1( p1[1] ), .gi2( g1[0] ), .go( g2[0] ) );
    black_cell A2 (.gi1( g1[3] ), .pi1( p1[3] ), .gi2( g1[2] ), .pi2( p1[2] ), .go( g2[1] ), .po( p2[1] ) );
    black_cell A3 (.gi1( g1[5] ), .pi1( p1[5] ), .gi2( g1[4] ), .pi2( p1[4] ), .go( g2[2] ), .po( p2[2] ) );
    black_cell A4 (.gi1( g1[7] ), .pi1( p1[7] ), .gi2( g1[6] ), .pi2( p1[6] ), .go( g2[3] ), .po( p2[3] ) );
    grey_cell A5 (.gi1( g1[2] ), .pi1( p1[2] ), .gi2( g2[0] ), .go( g3[0] ) );
    grey_cell A6 (.gi1( g2[1] ), .pi1( p2[1] ), .gi2( g2[0] ), .go( g3[1] ) );
    black_cell A7 (.gi1( g1[6] ), .pi1( p1[6] ), .gi2( g2[2] ), .pi2( p2[2] ), .go( g3[2] ), .po( p3[2] ) );
    black_cell A8 (.gi1( g2[3] ), .pi1( p2[3] ), .gi2( g2[2] ), .pi2( p2[2] ), .go( g3[3] ), .po( p3[3] ) );
    grey_cell A9 (.gi1( g1[4] ), .pi1( p1[4] ), .gi2( g3[1] ), .go( g4[0] ) );
    grey_cell A10 (.gi1( g2[2] ), .pi1( p2[2] ), .gi2( g3[1] ), .go( g4[1] ) );
    grey_cell A11 (.gi1( g3[2] ), .pi1( p3[2] ), .gi2( g3[1] ), .go( g4[2] ) );
    grey_cell A12 (.gi1( g3[3] ), .pi1( p3[3] ), .gi2( g3[1] ), .go( g4[3] ) );
    
    assign out[7:1] = p1[7:1] ^ { g4[2:0], g3[1], g3[0], g2[0], g1[0] };
    assign out[0] = p1[0];

endmodule  

module black_cell(gi1, pi1, gi2, pi2, go, po);
//gi1 is a combined generate signal from j to i
//pi1 is a combined propagate signal from j to i
//gi2 is a combined generate signal from m to j-1
//pi2 is a combined propagate signal from m to j-1
//go is a combined generate signal from m to i
//po is a combined propagate signal from m to i
    input gi1, pi1, gi2, pi2;
    output go, po;
    
    assign po = pi1 & pi2;
    assign go = ( gi2 & pi1 ) | gi1;
endmodule

module grey_cell(gi1, pi1, gi2, go);
//gi1 is a combined generate signal from j to i
//pi1 is a combined propagate signal from j to i
//gi2 is a combined generate signal from m to j-1
//go is a combined generate signal from m to i
//po is a combined propagate signal from m to i
    input gi1, pi1, gi2;
    output go;
    
    assign go = ( gi2 & pi1 ) | gi1;
endmodule

module ha(a, b, g, p);
    input a, b;
    output g, p;
    
    assign g = a & b;
    assign p = a ^ b;
endmodule

module fa(a, b, c, g, p);
    input a, b, c;
    output g, p;
    
    assign g = (a & b) | (b & c) | (c & a);
    assign p = a ^ b ^ c;
endmodule