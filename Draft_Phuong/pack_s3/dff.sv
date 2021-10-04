module dff(clk, rst, d, q);
//sync positive rst
//positive clk
    input clk, rst, d;
    output reg q;
    
    always @ (posedge clk) begin
        if (rst)
            q <= 0;
        else 
            q <= d;
    end
endmodule