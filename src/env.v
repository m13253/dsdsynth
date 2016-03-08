`include "def.v"
`define ENVELOPE_FREQ (`CLK_FREQ/65536)

module env(clk, clr, y);
    input clk; // ENVELOPE_FREQ
    input clr;
    output[`PCM_QUANT-2:0] y;
    
    reg[`PCM_QUANT-2:0] env_table[3*`ENVELOPE_FREQ-1:0];
    initial
        $readmemh("env_table.hex", env_table);

    reg[15:0] t = 0;

    always @(posedge clk) begin
        if(clr)
            t <= 0;
        else if(t != 3*`ENVELOPE_FREQ-1)
            t <= t + 1;
    end

    assign y = env_table[t];
endmodule
