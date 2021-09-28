`include "mod3_i8_o1.sv"
module ternary( input[5600:1] bit_str,
               input clk,
               input clk8,
               input rst,
               output logic [1400:1] v);
  logic[5600:1] reg_in;
  always @(posedge clk8)
    if (rst) begin 
      reg_in <= bit_str;
    end
    else begin
      reg_in <= reg_in >> 8;
      out <= out >> 2;
    end
  mod3_i8_o1 MOD3 (.rst(clk8), .clk(clk), .in(reg_in[8:1]), .out(v[1400:1399]));
endmodule
