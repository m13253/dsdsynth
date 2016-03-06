module top(clk, clki, clko, y);
    input clk;
    input clki;
    output clko;
    output y;

    assign clko = clki;

    reg[23:0] count = 0;

    wire[7:0] pcm;
    sin sin(count[23:16], pcm);
    dsm dsm(count[6], pcm, y);

    always @(posedge clk) begin
        count <= count + 1;
    end
endmodule
