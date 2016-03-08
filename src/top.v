`include "def.v"

module top(clk, ena, y);
    input clk;
    input ena;
    output y;

    reg[`SINE_QUANT-1:0] phase = 0;
    reg[15:0] freqdiv = 0;
    reg[8:0] oscdiv = 0;

    wire signed[`PCM_QUANT-1:0] sine_out;
    wire signed[`PCM_QUANT-1:0] env_out;
    wire signed[2*`PCM_QUANT:0] master;
    wire pdm;
    sin sin(phase, sine_out);
    env env(freqdiv[15], 1'b0, env_out);
    assign master = (sine_out * $signed({1'b0, env_out}));
    dsm dsm(clk, master[2*`PCM_QUANT-1:`PCM_QUANT], pdm);
    assign y = ena & pdm;

    always @(posedge clk) begin
        freqdiv <= freqdiv + 1;
        if(oscdiv != 298) // 20MHz / (262Hz * 256samp/round)
            oscdiv <= oscdiv + 1;
        else begin
            oscdiv <= 0;
            phase <= phase + 1;
        end
    end
endmodule
