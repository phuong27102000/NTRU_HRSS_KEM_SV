module Control_Unit(ovr_rst1, clk, fifo1_en, fifo2_en, fifo2_stop, p3_rst1, p3_rst2, p3_count, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin);
	parameter STOP_AT = 5;
	input ovr_rst1, clk;
	output fifo1_en, fifo2_en, fifo2_stop, p3_rst1, p3_rst2, hash_rst1, hash_rst2, hash_sp, hash_ans, hash_keccak, hash_clk, hash_fin;
	output [1:0] p3_count;
	reg [2:0] fifo1;
	reg [7:0] fifo2, stop;
	reg [1:0] hash;
	reg ovr_rst2;

	assign fifo1_en = clk;
	assign #0.1 fifo2_en = fifo1[1] & ( ~fifo1[2] ); //fifo1 = 2,3
	assign fifo2_stop = hash[1] & stop[2] & stop[0] & ( ~|{ stop[7:3], stop[1] } ); //hash >= 2 and stop = STOP_AT
	assign p3_rst1 = ~( |{ fifo1[2:1], ~fifo1[0] } ); //fifo1 = 1
	assign p3_rst2 = ~( |{ fifo1[2], ~fifo1[1], fifo1[0] } ); //fifo1 = 2
	assign p3_count = { |fifo1[2:1], fifo1[0] }; // ( fifo1, p3_count ) = ( 3, 3 ), ( 4, 2 ), ( 0, 0 ), ( 1, 1 )
	assign hash_rst1 = ~( |fifo2 ) & (~hash[1]) & hash[0]; //fifo2 = 0 and hash = 1
	assign hash_rst2 = ~( |{ fifo2[7:3], ~fifo2[2], fifo2[1:0] } ); //fifo2 = 4
	assign hash_sp = ~( |{ fifo2[7:2], ~( ^fifo2[1:0] ) } ); //fifo2 = 1,2
	assign hash_ans = ~( |{ fifo2[7:5], ~( &fifo2[4:1] ), fifo2[0] } ); //fifo2 = 30
	assign hash_keccak = fifo2[0];
	assign hash_clk = fifo2_en;
	assign hash_fin = ( hash[1] & hash[0] );
	assign hash_3rd_round = hash_fin & hash_ans;


	always @ ( posedge fifo1_en ) begin
		if (ovr_rst1 | (fifo1 == 4)) begin
			fifo1 <= 0;
		end
		else begin
			fifo1 <= fifo1 + 1;
		end
	end

	always @ ( posedge fifo2_en or posedge ovr_rst1 ) begin
		if (ovr_rst1) begin
			ovr_rst2 <= 1;
		end
		else begin
			ovr_rst2 <= 0;
		end
	end

	always @ ( posedge fifo2_en ) begin
		if (ovr_rst2 | (fifo2 == 68) | hash_3rd_round) begin
			fifo2 <= 0;
		end
		else begin
			fifo2 <= fifo2 + 1;
		end
	end

	always @ ( posedge fifo2_en ) begin
		if (fifo2_stop) begin
			stop <= STOP_AT;
		end
		else begin
			stop <= fifo2 + 1;
		end
	end

	always @ ( posedge ovr_rst1 or posedge hash_ans ) begin
		if (ovr_rst1) begin
			hash <= 0;
		end
		else begin
			hash <= hash + 1;
		end
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

endmodule
