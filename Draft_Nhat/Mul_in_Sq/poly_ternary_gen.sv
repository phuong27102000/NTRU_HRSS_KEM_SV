module poly_sq_gen (
	input logic clk,
	input logic en,
	input logic [9113:1] t,
	output reg [12:0] c
	);
	logic [9113:1] t2;
	logic [9113:1] t3;
	logic a;
	always @(posedge clk) begin
		
		if (en==1) begin
			t3=t;	
			
			c=t3[13:1];
			end
		else begin
		    
			t3=t3>>13;
			c=t3[13:1];
			
		    end
		
	end
endmodule


module lift_ternary_gen (
	input logic clk,
	input logic en,
	input logic [1400:1] t,
	output logic [4:1] r
	);
	logic [1400:1] t2;
	logic [1400:1] t3;
	logic a;
	always @(posedge clk) begin
		
		if (en==1) begin
			t3=t;	
			
			r=t3[4:1];
			end
		else begin
		  
			t2=t3>>4;
			r=t2[4:1];
			t3=t2;
		   
		end
	end
endmodule