`timescale 1ns/1ns

module top(
    input clk,
    input [3:0] rst,
    output hsync,
    output vsync,
    output r,
    output g,
    output b,
    output y,
    output [6:0] led
);
    wire pll = clk;
    //vgapll vgapll(.inclk0(clk), .c0(pll));
    wire [10:0] pos;
    reg [7:0] char;
    always @(posedge pll)
        char <= pos[0] ? 65 : (128+66);
    vga vga(pll, hsync, vsync, r, g, b, pos, char);

    wire [15:0] pcm;
    reg [31:0] cnt = 0;
    always @(posedge clk) cnt <= cnt + 1;
    synth synth(
        clk,
        !rst[0], !rst[1], !rst[2], !rst[3],
        60, 62, 64, 65,
        pcm
    );
    dsm dsm(clk, pcm, y);
    
    assign led[6] = pcm[15];
    assign led[5:0] = pcm[15] ? -pcm[14:9] : pcm[14:9];

endmodule
