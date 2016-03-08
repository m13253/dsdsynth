`include "def.v"

module note(clk, clr, cyc, y);
    input clk;
    input clr;
    input[15:0] cyc;
    output signed[`PCM_QUANT-1:0] y;

    reg[`SINE_QUANT-1:0] phase = 0;
    reg[15:0] freqdiv = 0;

    always @(posedge clk) begin
        if(clr) begin
            phase <= 0;
            freqdiv <= 0;
        end else if(freqdiv >= cyc) begin
            phase <= phase + 1;
            freqdiv <= 0;
        end else
            freqdiv <= freqdiv + 1;
    end

    reg harmony = 0;
    reg signed[`PCM_QUANT-1:0] harm_y[1:0];
    wire signed[`PCM_QUANT-1:0] harm_bus;
    sin sin(harmony ? phase << 1 : phase, harm_bus);
    always @(posedge clk) begin
        harmony <= ~harmony;
        if(harmony)
            harm_y[1] <= harm_bus;
        else
            harm_y[0] <= harm_bus;
    end

    initial begin
        harm_y[0] <= 0;
        harm_y[1] <= 0;
    end
    assign y = (harm_y[0]>>1) + (harm_y[1]>>2);
endmodule
