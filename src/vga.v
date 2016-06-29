module vga(
    input clk,
    output hsync,
    output vsync,
    output r,
    output g,
    output b,
    output [10:0] pos,
    input [7:0] char
);
    reg [10:0] x_2 = 0;
    reg [10:0] y_2 = 0;
    reg [10:0] x_1;
    reg [10:0] y_1;
    reg [10:0] x_0;
    reg [10:0] y_0;

    always @(posedge clk) begin
        if(x_2 == 799) begin
            x_2 <= 0;
            y_2 <= y_2 == 499 ? 0 : y_2 + 1;
        end else
            x_2 <= x_2 + 1;
        x_1 <= x_2;
        y_1 <= y_2;
        x_0 <= x_1;
        y_0 <= y_1;
    end

    wire [10:0] cx = x_2 >> 3;
    wire [10:0] cy = (y_2-11'd40) >> 4;
    assign pos = (cy << 4) + ((cy << 6) | cx);

    assign hsync = !(x_0 >= 664 && x_0 < 720);
    assign vsync = (y_0 >= 483 && y_0 < 487);

    reg [7:0] font [1535:0];
    initial
        $readmemh("../font/font.hex", font);

    reg [7:0] fontline;
    always @(posedge clk)
        fontline <= font[{char[6:0], y_1[3:0]+4'd8}];

    reg invert;
    always @(posedge clk)
        invert <= char[7];

    wire [7:0] fontbit = fontline << x_0[2:0];
    wire valid = x_0 < 640 && y_0 >= 40 && y_0 < 440;
    wire w = valid & (fontbit[7] ^ invert);

    assign r = w;
    assign g = w;
    assign b = w;
endmodule
