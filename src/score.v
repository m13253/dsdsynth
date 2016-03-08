`include "def.v"

module score(clk, cyc, attack);
    input clk;
    output[15:0] cyc;
    output attack;

    reg[31:0] score[31:0];
    initial
        $readmemh("score.hex", score);
    wire[31:0] score_item = score[pointer];
    assign cyc = score_item[31:16];

    reg[4:0] pointer = 0;
    reg[31:0] delay = 0;

    assign attack = delay == 0;

    always @(negedge clk) begin
        if(delay == 0) begin
            delay <= score_item << 16;
            pointer <= pointer + 1;
        end else begin
            delay <= delay - 1;
        end
    end
endmodule
