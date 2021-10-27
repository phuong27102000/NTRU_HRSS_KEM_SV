module decrypt #(parameter NUMS_OF_A_TER=700*2, parameter NUMS_OF_A_SQ=700*13)
(
input logic clk,
input logic en_lift,en_poly,
input logic [NUMS_OF_A_TER:1] m,
input logic [NUMS_OF_A_TER+2:1]rin,
input logic [NUMS_OF_A_SQ+13:1] h,
output logic [NUMS_OF_A_SQ+13:1] b,
output logic [NUMS_OF_A_SQ+13:1] e,c1,
output logic [NUMS_OF_A_SQ+4:1] c2
);

lift lift (.clk(clk),.en(en_lift),.m(m),.b(b));
polynomialmultiplication polynomialmultiplication (.clk(clk),.en(en_poly),.rin(rin),.h(h),.e_1(e));
Add_in_Rq Add_in_Rq (.v(e),.m1(b),.c(c1));
pack_Rq0 pack_Rq0 (.c(c1),.cnew(c2));

endmodule