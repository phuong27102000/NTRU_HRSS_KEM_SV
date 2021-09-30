`include "mod3_i8_o1.sv"
module ternary(bit_str, clk, rst, v);
    input[5600:1] bit_str;
    input clk;
    input rst;
    output logic [1400:1] v;
    logic[5600:1] reg_in;
    logic[1:0] now, then, count;
    parameter[1:0] MOD3 = 0, MOD3_DONE = 1, INIT = 2, WAIT = 3, MOD3 = 0;
  
    always_comb begin
        case(now)
            INIT: begin 
                then <= MOD3;
                reg_in <= bit_str;
            end
            WAIT: begin
                then <= MOD3;
                reg_in <= reg_in >> 32;
                v <= v >> 8;
                count <= 0;
            end
            MOD3: begin 
               if (count == 3) then <= MOD3_DONE;
               else then <= MOD3;
               count <= count + 1;
            end
            MOD3_DONE: begin
                then <= WAIT;
            end
    end
    always @(posedge clk) begin
        if (rst) now <= INIT;
        else now <= then;
    end
    mod3_i8_o1 MOD3_0 (.rst(now[1]), .clk(clk), .in(reg_in[32:25]), .out(v[1400:1399]));
    mod3_i8_o1 MOD3_1 (.rst(now[1]), .clk(clk), .in(reg_in[24:17]), .out(v[1398:1397]));
    mod3_i8_o1 MOD3_2 (.rst(now[1]), .clk(clk), .in(reg_in[16:9]), .out(v[1396:1395]));
    mod3_i8_o1 MOD3_3 (.rst(now[1]), .clk(clk), .in(reg_in[8:1]), .out(v[1394:1393]));
endmodule
