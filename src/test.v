`timescale 1us/1us

module test;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        #1000000 $finish;
    end

    reg clk = 0;
    always begin
        #5 clk <= ~clk;
    end

    wire y;

    top top(
        .clk(clk), .y(y)
    );

endmodule

