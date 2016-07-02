module scores(
    input clk,
    input grst,
    output rst0,
    output rst1,
    output rst2,
    output rst3,
    output [6:0] key0,
    output [6:0] key1,
    output [6:0] key2,
    output [6:0] key3,
    input [10:0] pos,
    output [7:0] char,
    output [7:0] seg
);
    reg [14:0] div = 0;
    always @(posedge clk)
        div <= div+1;
        
    reg [6:0] note0 [2047:0];
    initial
        $readmemh("../score/note0.hex", note0);
    reg [6:0] note1 [1023:0];
    initial
        $readmemh("../score/note1.hex", note1);
    reg [6:0] note2 [1023:0];
    initial
        $readmemh("../score/note2.hex", note2);
    reg [6:0] note3 [1023:0];
    initial
        $readmemh("../score/note3.hex", note3);
    reg [15:0] dur0 [2047:0];
    initial
        $readmemh("../score/time0.hex", dur0);
    reg [15:0] dur1 [1023:0];
    initial
        $readmemh("../score/time1.hex", dur1);
    reg [15:0] dur2 [1023:0];
    initial
        $readmemh("../score/time2.hex", dur2);
    reg [15:0] dur3 [1023:0];
    initial
        $readmemh("../score/time3.hex", dur3);

    wire [15:0] addr0 [3:0];
    wire [15:0] addr1 [3:0];
    reg [6:0] note [3:0]; 
    reg [15:0] dur [3:0]; 
    always @(posedge div[13]) begin
        note[0] <= note0[addr0[0]];
        note[1] <= note1[addr0[1]];
        note[2] <= note2[addr0[2]];
        note[3] <= note3[addr0[3]];
        dur[0] <= dur0[addr1[0]];
        dur[1] <= dur1[addr1[1]];
        dur[2] <= dur2[addr1[2]];
        dur[3] <= dur3[addr1[3]];
    end
    
    assign seg = addr0[0][7:0];
    
    score score0(.clk(div[13]), .grst(grst), .addr0(addr0[0]), .addr1(addr1[0]), .note(note[0]), .dur(dur[0]), .rst(rst0), .key(key0));
    score score1(.clk(div[13]), .grst(grst), .addr0(addr0[1]), .addr1(addr1[1]), .note(note[1]), .dur(dur[1]), .rst(rst1), .key(key1));
    score score2(.clk(div[13]), .grst(grst), .addr0(addr0[2]), .addr1(addr1[2]), .note(note[2]), .dur(dur[2]), .rst(rst2), .key(key2));
    score score3(.clk(div[13]), .grst(grst), .addr0(addr0[3]), .addr1(addr1[3]), .note(note[3]), .dur(dur[3]), .rst(rst3), .key(key3));

    framebuffer framebuffer(
        clk,
        key0, key1, key2, key3,
        pos, char
    );
endmodule
