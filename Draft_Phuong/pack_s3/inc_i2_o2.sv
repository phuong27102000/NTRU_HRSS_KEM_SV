module inc_i2_o2(a, out);
    input[1:0] a;
    output[1:0] out;
    
    assign out[0] = ~a[0];
    assign out[1] = a[1] ^ a[0];
      
endmodule