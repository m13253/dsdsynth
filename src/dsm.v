module dsm(clk, pcm, y);
    input clk;
    input[7:0] pcm;
    output y;
    reg y;

    reg[9:0] acc1 = 0;
    reg[9:0] acc2 = 0;
    reg[9:0] feedback = 0;
 
    always @(posedge clk) begin
        acc1 = acc1 + $signed(pcm) + feedback;
        acc2 = acc2 + acc1 + feedback;
        feedback <= acc2[9] ? 127 : -127;
        y <= acc2[9];
    end
endmodule
