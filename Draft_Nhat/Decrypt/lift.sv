module lift #(parameter NUMS_OF_A_TER=700*2, parameter NUMS_OF_A_SQ=700*13)
(
input logic clk,
input logic en,
input logic [4:1] m,
output logic [NUMS_OF_A_SQ+13:1] b,
output logic [26:1] m_sq
);

bit_map bit_map (.a_ter(m), .a_sq(m_sq));
vector_mul vector_mul (.clk(clk),.en(en),.v(m_sq),.b_out(b));
endmodule
