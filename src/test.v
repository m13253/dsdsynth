`timescale 1us/1us

module test;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        #10000 $finish;
    end

    reg clk = 0;
    always begin
        #5 clk <= ~clk;
    end

    wire[7:0] pcm;

    top top(
        .clk(clk), .pcm(pcm)
    );

endmodule

