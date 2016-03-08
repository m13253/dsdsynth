module top(clk, ena, y);
    input clk;
    input ena;
    output y;

    reg[7:0] phase = 0;
    reg[8:0] freqdev = 0;

    wire[7:0] pcm;
    wire pdm;
    sin sin(phase, pcm);
    dsm dsm(clk, pcm, pdm);
    assign y = ena & pdm;

    always @(posedge clk) begin
        if(freqdev != 298) // 20MHz / (262Hz * 256samp/round)
            freqdev <= freqdev + 1;
        else begin
            freqdev <= 0;
            phase <= phase + 1;
        end
    end
endmodule
