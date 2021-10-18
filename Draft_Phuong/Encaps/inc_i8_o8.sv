module inc_i8_o8(a, out);
//Sklansky AND-prefix structure
    input[7:0] a;
    output[7:0] out;
    wire[10:0] b;
    
    assign b[0] = a[1]&a[2];
    assign b[1] = a[3]&a[4];
    assign b[2] = a[5]&a[6];
    assign b[3] = a[0]&a[1];
    assign b[4] = a[0]&b[0];
    assign b[5] = a[5]&b[1];
    assign b[6] = b[2]&b[1];
    assign b[7] = a[3]&b[4];
    assign b[8] = b[1]&b[4];
    assign b[9] = b[4]&b[5];
    assign b[10] = b[4]&b[6];
    assign out[0] = ~a[0];
    assign out[1] = a[1]^a[0];
    assign out[2] = a[2]^b[3];
    assign out[3] = a[3]^b[4];
    assign out[4] = a[4]^b[7];
    assign out[5] = a[5]^b[8];
    assign out[6] = a[6]^b[9];
    assign out[7] = a[7]^b[10];
      
endmodule