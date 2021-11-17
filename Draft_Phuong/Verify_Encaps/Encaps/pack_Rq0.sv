`timescale 1ns / 1ps

module pack_Rq0(c, cnew);
	input [9113:1] c;
	output [9104:1] cnew;
	generate
        genvar i;
        for (i = 0; i < 1137; i = i + 1)
        begin: MAP
            assign cnew[9104-8*i : 9097-8*i] = c[8*i+8 : 8*i+1];
        end
    endgenerate
	assign cnew[8:5] = 4'd0;
	assign cnew[4:1] = c[9100:9097];
endmodule
