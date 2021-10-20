// `include "ppa_sk.sv"
module add_2i13_o13(x1, x2, out);
	parameter NUM_BIT = 13;

    input[NUM_BIT-1 : 0] x1;
    input[NUM_BIT-1 : 0] x2;
    output[NUM_BIT-1 : 0] out;
    wire[NUM_BIT-1 : 0] g0,p0,g1,p1,g2,p2,g3,p3,g4;

	generate
		genvar i;
		for (i = 0; i < NUM_BIT; i = i + 1)
		begin: HA_SLICE
			ha A0 ( .a( x1[i] ), .b( x2[i] ), .g( g0[i] ), .p( p0[i] ) );
		end
	endgenerate

    grey_cell A1_1 ( .gi1( g0[1] ), .pi1( p0[1] ), .gi2( g0[0] ), .go( g1[1] ) );
    black_cell A1_3 ( .gi1( g0[3] ), .pi1( p0[3] ), .gi2( g0[2] ), .pi2( p0[2] ), .go( g1[3] ), .po( p1[3] ) );
    black_cell A1_5 ( .gi1( g0[5] ), .pi1( p0[5] ), .gi2( g0[4] ), .pi2( p0[4] ), .go( g1[5] ), .po( p1[5] ) );
    black_cell A1_7 ( .gi1( g0[7] ), .pi1( p0[7] ), .gi2( g0[6] ), .pi2( p0[6] ), .go( g1[7] ), .po( p1[7] ) );
	black_cell A1_9 ( .gi1( g0[9] ), .pi1( p0[9] ), .gi2( g0[8] ), .pi2( p0[8] ), .go( g1[9] ), .po( p1[9] ) );
	black_cell A1_11 ( .gi1( g0[11] ), .pi1( p0[11] ), .gi2( g0[10] ), .pi2( p0[10] ), .go( g1[11] ), .po( p1[11] ) );

	grey_cell A2_2 ( .gi1( g0[2] ), .pi1( p0[2] ), .gi2( g1[1] ), .go( g2[2] ) );
    grey_cell A2_3 ( .gi1( g1[3] ), .pi1( p1[3] ), .gi2( g1[1] ), .go( g2[3] ) );
    black_cell A2_6 ( .gi1( g0[6] ), .pi1( p0[6] ), .gi2( g1[5] ), .pi2( p1[5] ), .go( g2[6] ), .po( p2[6] ) );
    black_cell A2_7 ( .gi1( g1[7] ), .pi1( p1[7] ), .gi2( g1[5] ), .pi2( p1[5] ), .go( g2[7] ), .po( p2[7] ) );
	black_cell A2_10 ( .gi1( g0[10] ), .pi1( p0[10] ), .gi2( g1[9] ), .pi2( p1[9] ), .go( g2[10] ), .po( p2[10] ) );
	black_cell A2_11 ( .gi1( g1[11] ), .pi1( p1[11] ), .gi2( g1[9] ), .pi2( p1[9] ), .go( g2[11] ), .po( p2[11] ) );

	grey_cell A3_4 (.gi1( g0[4] ), .pi1( p0[4] ), .gi2( g2[3] ), .go( g3[4] ) );
    grey_cell A3_5 (.gi1( g1[5] ), .pi1( p1[5] ), .gi2( g2[3] ), .go( g3[5] ) );
    grey_cell A3_6 (.gi1( g2[6] ), .pi1( p2[6] ), .gi2( g2[3] ), .go( g3[6] ) );
    grey_cell A3_7 (.gi1( g2[7] ), .pi1( p2[7] ), .gi2( g2[3] ), .go( g3[7] ) );
	black_cell A3_12 ( .gi1( g0[12] ), .pi1( p0[12] ), .gi2( g2[11] ), .pi2( p2[11] ), .go( g3[12] ), .po( p3[12] ) );

	grey_cell A4_8 (.gi1( g0[8] ), .pi1( p0[8] ), .gi2( g3[7] ), .go( g4[8] ) );
	grey_cell A4_9 (.gi1( g1[9] ), .pi1( p1[9] ), .gi2( g3[7] ), .go( g4[9] ) );
	grey_cell A4_10 (.gi1( g2[10] ), .pi1( p2[10] ), .gi2( g3[7] ), .go( g4[10] ) );
	grey_cell A4_11 (.gi1( g2[11] ), .pi1( p2[11] ), .gi2( g3[7] ), .go( g4[11] ) );
	grey_cell A4_12 (.gi1( g3[12] ), .pi1( p3[12] ), .gi2( g3[7] ), .go( g4[12] ) );

    assign #0.1 out[NUM_BIT-1 : 1] = p0[NUM_BIT-1 : 1] ^ { g4[11:8], g3[7:4], g2[3:2], g1[1], g0[0] };
    assign #0.1 out[0] = p0[0];

endmodule // add_2i13_o13
