`include "def.v"

module score(clk, cyc, attack);
    input clk;
    output[15:0] cyc;
    output attack;
    reg[15:0] cyc = 0;
    reg attack = 0;

    reg[31:0] score[63:0];
    initial
        $readmemh("score.hex", score);
    wire[31:0] score_item = score[pointer];

    reg[5:0] pointer = 0;
    reg[15:0] delay = 0;

    always @(negedge clk) begin
        if(delay == 0) begin
            attack <= 1;
            cyc <= score_item[31:16];
            delay <= score_item[15:0];
            pointer <= pointer + 1;
        end else begin
            attack <= 0;
            delay <= delay - 1;
        end
    end
endmodule
