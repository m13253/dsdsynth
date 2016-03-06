module sin(clk, grad, y);
    input clk;
    input[7:0] grad; // 0 -> 0, 256 -> 2*pi
    output[7:0] y; // -1 -> -255, 1 -> 255
    reg[7:0] y;
    
    reg[7:0] sin_table[127:0];
    initial
        $readmemh("sin_table.hex", sin_table);

    wire[7:0] abs;
    assign abs = sin_table[grad[6:0]];
    
    always @(posedge clk)
        y <= grad[7] ? ~abs : abs;
endmodule
