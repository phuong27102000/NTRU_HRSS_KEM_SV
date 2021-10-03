module testbench;
  reg[7:0] x1;
  reg[7:0] x2;
  wire[7:0] out;
  integer a,b;

  ppa_sk_i8_o8 A (x1, x2, out);
  
  initial begin
    for (a=0;a<256; a = a+1) begin
      for (b=0;b<256; b = b+1) begin
        x1 = a;
        x2 = b;
        #2;
      end
    end
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule
