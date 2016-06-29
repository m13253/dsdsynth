module dsm(
    input clk,
    input signed [15:0] pcm,
    output y
);
    wire signed[31:0] compress = {{16{pcm[13]}}, pcm[13:0], 2'b0};
    reg signed[31:0] acc1 = 0;
    reg signed[31:0] acc2 = 0;
    reg signed[31:0] feedback = 0;

    always @(posedge clk) begin
        acc1 = acc1 + compress + feedback;
        acc2 = acc2 + acc1 + feedback;
        feedback <= acc2[31] ? 32767 : -32767;
    end
    assign y = acc2[31];
endmodule
