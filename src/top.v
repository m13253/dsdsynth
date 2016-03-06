module top(clk, pcm);
    input clk;
    output[7:0] pcm;

    reg[7:0] count = 0;

    sin sin(count, pcm);

    always @(posedge clk) begin
        count <= count + 1;
    end
endmodule
