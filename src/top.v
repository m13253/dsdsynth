module top(clk, y);
    input clk;
    output y;

    reg[11:0] count = 0;

    wire[7:0] pcm;
    sin sin(count[11:4], pcm);
    dsm dsm(clk, pcm, y);

    always @(posedge clk) begin
        count <= count + 1;
    end
endmodule
