module score(
    input clk, // 1220.70 Hz
    input grst,
    output [15:0] addr0,
    output [15:0] addr1,
    input [6:0] note,
    input [15:0] dur,
    output rst,
    output [6:0] key
);
    reg [15:0] addr_cnt = 0;
    assign addr0 = addr_cnt;
    assign addr1 = addr_cnt+2;
    reg [15:0] count = 0;
    always @(posedge clk, posedge grst)
        if(grst) begin
            addr_cnt <= 0;
            count <= 0;
        end else if(count == 0) begin
            addr_cnt <= addr_cnt+1;
            count <= dur-1;
        end else
            count <= count-1;
    assign rst = count == 0;
    assign key = note;
endmodule
