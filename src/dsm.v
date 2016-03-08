`include "def.v"

module dsm(clk, pcm, y);
    input clk; // CLK_FREQ
    input signed[`PCM_QUANT-1:0] pcm;
    output y;

    reg signed[`PCM_QUANT+1:0] acc1 = 0;
    reg signed[`PCM_QUANT+1:0] acc2 = 0;
    reg signed[`PCM_QUANT+1:0] feedback = 0;

    always @(posedge clk) begin
        acc1 = acc1 + pcm + feedback;
        acc2 = acc2 + acc1 + feedback;
        feedback <= acc2[`PCM_QUANT+1] ? (1<<(`PCM_QUANT-1))-1 : 1-(1<<(`PCM_QUANT-1));
    end
    assign y = acc2[`PCM_QUANT+1];
endmodule
