`timescale 1ns/1ns

module top(
    input clk,
    input rst,
    input [3:0] mute,
    output hsync,
    output vsync,
    output r,
    output g,
    output b,
    output y,
    output [6:0] led,
    output [7:0] seg
);
    wire [10:0] pos;
    wire [7:0] char;
    vga vga(clk, hsync, vsync, r, g, b, pos, char);

    wire track_rst [3:0];
    wire [6:0] track_key [3:0];
    scores scores(
        .clk(clk), .grst(!rst),
        .rst0(track_rst[0]), .rst1(track_rst[1]), .rst2(track_rst[2]), .rst3(track_rst[3]),
        .key0(track_key[0]), .key1(track_key[1]), .key2(track_key[2]), .key3(track_key[3]),
        .pos(pos), .char(char), .seg(seg)
    );

    wire [15:0] pcm;
    reg [31:0] cnt = 0;
    always @(posedge clk) cnt <= cnt + 1;
    synth synth(
        clk,
        track_rst[0], track_rst[1], track_rst[2], track_rst[3],
        track_key[0], track_key[1], track_key[2], track_key[3],
        ~mute,
        pcm
    );
    dsm dsm(clk, pcm, y);

    assign led[6] = pcm[15];
    assign led[5:0] = pcm[15] ? -pcm[14:9] : pcm[14:9];

endmodule
