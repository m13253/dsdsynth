`include "def.v"

module top(clk, ena, y);
    input clk;
    input ena;
    output y;

    reg[15:0] freqdiv = 0;
    always @(posedge clk)
        freqdiv <= freqdiv +1;

    wire attack;
    wire[15:0] cyc;
    score score(clk, cyc, attack);
    wire signed[`PCM_QUANT-1:0] note_out;
    wire signed[`PCM_QUANT-2:0] env_out;
    wire signed[2*`PCM_QUANT-1:0] master;
    wire pdm;
    note note(clk, attack, cyc, note_out);
    env env(freqdiv[15], attack, env_out);
    assign master = (note_out * $signed({1'b0, env_out}));
    dsm dsm(clk, master[2*`PCM_QUANT-2:`PCM_QUANT-1], pdm);
    assign y = ena & pdm;
endmodule
