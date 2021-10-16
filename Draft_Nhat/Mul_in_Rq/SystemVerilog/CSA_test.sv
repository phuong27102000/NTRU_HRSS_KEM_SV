module CSA_test ;
reg [31:0]in1,in2;
reg cin;
wire [31:0]out;
initial begin
$monitor("in_1=%h  in_2=%h  out=%h ",in1,in2,out);
in1=13'd120;
in2=13'd1203;
cin=1'b0;
end
carryselectadder entity_0 ( .in1(in1), .in2(in2), .cin(cin) ,.out(out));
endmodule