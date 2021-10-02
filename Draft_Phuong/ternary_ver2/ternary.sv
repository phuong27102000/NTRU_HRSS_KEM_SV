`include "mod3.sv"
`include "inc.sv"
module ternary(bit_str, clk, rst, out, now, mod3, count);
//bit_str has 5600 bit-length
//1 iteration costs 6 periods of clk, INIT costs 1 periods of clk
//There is 1400/8 = 175 iteration, so this module costs 175*6+1 = 1051 periods of clk
//rst must be after bit_str 1 period of clk
    input[5600:1] bit_str;
    input clk,rst;
    output reg [1400:1] out;
    reg[5600:1] reg_in;
    reg[2:0] then;
    output reg[2:0] now;
    reg [7:0] v;
    output mod3;
    localparam [2:0] INIT = 7, MOD3p1 = 0, MOD3p2 = 1, MOD3p3 = 2, MOD3p4 = 3, DONE = 4, WAIT = 5, ENDING = 6;
    output reg[7:0] count;
    wire[7:0] count_next;
    localparam [7:0] iter_bound = 175;
   
    always @* begin
        case(now)
            INIT: then = MOD3p1;
            MOD3p1: then = MOD3p2;
            MOD3p2: then = MOD3p3;
            MOD3p3: then = MOD3p4;
            MOD3p4: then = DONE;
            DONE: begin 
                if (count == iter_bound) then = ENDING;
                else then = WAIT;
            end
            WAIT: then = INIT;
            ENDING: then = ENDING;
            default: then = 2'bxx;
        endcase
    end
      
    always @(negedge mod3 or posedge rst) begin
        if(rst) count <= 0;
        else count <= count_next;
    end

    assign mod3 = &now[2:1];
    
    always @(posedge clk)
        if (rst) begin 
            now <= INIT;
        end
        else now <= then;
// need more clearly      
    always @(posedge clk)
        if (rst) begin 
            reg_in <= bit_str;
            out <= 1400'b00;
        end
        else now <= then;
    
    always @(negedge clk)
        if (now == WAIT) begin
            out <= out >> 8;
            reg_in <= reg_in >> 32;
        end
        else if (now == DONE) 
            out[1400:1393] <= v;
//  need more clearly 
    
    inc_i8_o8 INC (count, count_next);
    
    mod3_i8_o1_excount MOD3_0 (.rst(mod3), .clk(~clk), .a(reg_in[32:25]), .out(v[7:6]), .count(now[1:0]) );
    mod3_i8_o1_excount MOD3_1 (.rst(mod3), .clk(~clk), .a(reg_in[24:17]), .out(v[5:4]), .count(now[1:0]) );
    mod3_i8_o1_excount MOD3_2 (.rst(mod3), .clk(~clk), .a(reg_in[16:9]), .out(v[3:2]), .count(now[1:0]) );
    mod3_i8_o1_excount MOD3_3 (.rst(mod3), .clk(~clk), .a(reg_in[8:1]), .out(v[1:0]), .count(now[1:0]) );
endmodule