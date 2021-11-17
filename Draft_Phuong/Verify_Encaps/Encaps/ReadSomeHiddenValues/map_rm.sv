`timescale 1ns / 1ps

module map_r (rst, r_clk, r_bits, r);
    input rst, r_clk;
    input [2:1] r_bits;
    output reg [1400:1] r;
    reg done;

    assign clk = r_clk & (~done);
    always @ ( posedge rst or posedge clk ) begin
        if (rst) begin
            r[1400:1] <= 1300'b01;
            done <= 0;
        end else begin #0.2
            r <= {r[1398:1], r_bits};
            done <= r[1399];
        end
    end

endmodule // map_r

module map_m (rst, m_clk, m_bits, m);
    input rst, m_clk;
    input [4:1] m_bits;
    output reg [1400:1] m;
    reg done;

    assign clk = m_clk & (~done);
    always @ ( posedge rst or posedge clk ) begin
        if (rst) begin
            m[1400:1] <= 1300'b01;
            done <= 0;
        end else begin #0.2
            m <= {m[1396:1], m_bits[2:1], m_bits[4:3]};
            done <= m[1397];
        end
    end

endmodule // map_m

