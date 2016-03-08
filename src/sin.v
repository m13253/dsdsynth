`include "def.v"

module sin(grad, y);
    input[`PCM_QUANT-1:0] grad; // 0 -> 0, 256 -> 2*pi
    output signed[`PCM_QUANT-1:0] y; // -1 -> -255, 1 -> 255

    reg[`PCM_QUANT-1:0] sin_table[(1<<(`SINE_QUANT-2))-1:0];
    initial
        $readmemh("sin_table.hex", sin_table);

    wire[`PCM_QUANT-1:0] abs;
    assign abs = sin_table[{grad[`SINE_QUANT-2] ? ~grad[`SINE_QUANT-3:0] : grad[`SINE_QUANT-3:0]}];
    assign y = grad[`SINE_QUANT-1] ? ~abs : abs;
endmodule
