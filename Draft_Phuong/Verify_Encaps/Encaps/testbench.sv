`timescale 1ns / 1ps

module testbench;
	parameter CIPHERTEXT_BITS = 9104;
	integer f_read, f_write;
	// reg [8:0] lfsr_delay;
    	reg lfsr_rst, ovr_rst1, clk;
    	reg [CIPHERTEXT_BITS:1] h_in;
    	wire [CIPHERTEXT_BITS:1] c;
    	wire [256:1] k;

   	encapsulate ENCAPS (lfsr_rst, ovr_rst1, clk, h_in, c, k);

//------------------------------------------------------------------------------
//  testbench
	
	parameter DELAY = 0;

	initial begin
		f_read = $fopen("../report/SV_public_key.txt","r");
		while (! $feof(f_read)) begin
			$fscanf(f_read,"Public_key: %h",h_in);
		end
		$fclose(f_read);
	end
	initial begin
		clk = 1;
		forever begin
			#0.5 clk = ~clk;
		end
	end

	initial begin
		lfsr_rst = 1;
		#1.2 lfsr_rst = 0;
	end

	initial begin
		ovr_rst1 = 0;
		#20.2;
		// lfsr_delay = $urandom;
		// $display("Delay: %d", lfsr_delay);
		// #(lfsr_delay);
		#(DELAY);
		$display("Delay: %d", DELAY);
		ovr_rst1 = 1;
		#1;
		ovr_rst1 = 0;
		#2000;

	    	f_write = $fopen("../report/SV_encaps.txt","w");
		$fwrite(f_write,"Ciphertext:\n%H\n",c);
		$fwrite(f_write,"Shared_key:\n%H\n",k);
		$fclose(f_write);
		$finish;
	end
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Generate waveform
	initial begin
		$dumpfile("../report/dump.vcd");
		$dumpvars(1);
	end
//------------------------------------------------------------------------------
endmodule // testbench
