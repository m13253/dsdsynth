module top(clk, clki, clko, y);
    input clk;
    input clki;
    output clko;
    output y;

    assign clko = clki;

    reg[7:0] phase = 0;
    reg[8:0] freqdev = 0;

    wire[7:0] pcm;
    sin sin(phase, pcm);
    dsm dsm(clk, pcm, y);

    always @(posedge clk) begin
        if(freqdev != 298) // 20MHz / (262Hz * 256samp/round)
            freqdev <= freqdev + 1;
        else begin
            freqdev <= 0;
            phase <= phase + 1;
        end
    end
endmodule
