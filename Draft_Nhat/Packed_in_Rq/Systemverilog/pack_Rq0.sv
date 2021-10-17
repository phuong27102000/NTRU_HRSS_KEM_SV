module pack_Rq0(
input logic [9113:1]c,
output logic [9104:1]cnew
);
generate
for (genvar i=1;i<=1137;i=i+1)begin
	assign cnew[i*8]=c[(i-1)*8+1];
	assign cnew[i*8-1]=c[(i-1)*8+2];
	assign cnew[i*8-2]=c[(i-1)*8+3];
	assign cnew[i*8-3]=c[(i-1)*8+4];
	assign cnew[i*8-4]=c[(i-1)*8+5];
	assign cnew[i*8-5]=c[(i-1)*8+6];
	assign cnew[i*8-6]=c[(i-1)*8+7];
	assign cnew[i*8-7]=c[(i-1)*8+8];
end 
endgenerate
assign cnew[9100:9097]=4'd0;
assign cnew[9101]=c[9100];
assign cnew[9102]=c[9099];
assign cnew[9103]=c[9098];
assign cnew[9104]=c[9097];
endmodule