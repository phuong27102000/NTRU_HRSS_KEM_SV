`include "trit5_to_bit8.sv"
`include "inc_i8_o8.sv"

module pack_s3(rst, clk, a, out, work, now);
    input [1400:1] a;
    input rst, clk;
    output reg[1120:1] out;
    output work;
    output [2:0] now;
    localparam [2:0] INIT = 7, TRANSp1 = 0, TRANSp2 = 1, TRANSp3 = 2, TRANSp4 = 3, WAIT = 4, DONE = 5, ENDING = 6;
    localparam [7:0] ITER_BOUND = 140;
    reg[2:0] now, then;
    reg[7:0] count;
    wire[7:0] count_new, v;
    
    reg [1400:1] reg_in;
    reg work;
    
    trit5_to_bit8 TRIT2BIT ( .rst( work ), .clk( ~clk ), .a( reg_in[10:1] ), .out( v ), .count( now[1:0] ) );
    inc_i8_o8 INC ( .a( count ), .out( count_new ) );
    
    always @* begin
        case(now)
            INIT: then = TRANSp1;
            TRANSp1: then = TRANSp2;
            TRANSp2: then = TRANSp3;
            TRANSp3: then = TRANSp4;
            TRANSp4: then = WAIT;
            WAIT: then = DONE;
            DONE: begin
                if ( count == ITER_BOUND ) then = ENDING;
                else then = INIT;
            end
            ENDING: then = ENDING;
            default: then = 2'bxx;
        endcase
    end
    
    always @(posedge work or posedge rst)
        if (rst)
            count <= 0;
        else
            count <= count_new;
    
    always @(posedge clk)
        if (rst) begin 
            now <= INIT;
        end
        else now <= then;
    
    always @(negedge clk)
        work <= now[2] & ( ( ~now[2] ) | now[1] | now[0] );
    
// need more clearly      
    always @(posedge clk)
        if (rst) begin 
            reg_in <= a;
            out <= 1120'b00;
        end
    
    always @(negedge clk)
        if (now == DONE) begin
            out <= out >> 8;
            reg_in <= reg_in >> 10;
        end
        else if (now == WAIT) 
            out[1120:1113] <= v;
//  need more clearly 
    
endmodule
    