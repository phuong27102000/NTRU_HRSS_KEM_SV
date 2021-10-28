module bit_map #(parameter NUMS_OF_A_TER=2*2, parameter NUMS_OF_A_SQ=2*13)
(
input logic [NUMS_OF_A_TER:1]a_ter,
output logic [NUMS_OF_A_SQ:1]a_sq
);
genvar i;
generate
for (i=1;i<=NUMS_OF_A_TER/2;i=i+1) begin
	assign a_sq[(i-1)*13+1]=a_ter[(i-1)*2+1];
	assign	a_sq[(i-1)*13+13:(i-1)*13+2]={12{a_ter[(i-1)*2+2]}};
end
endgenerate

endmodule