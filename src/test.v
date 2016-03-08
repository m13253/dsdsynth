`timescale 10ns/1ns

module test;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        #10000000 $finish;
    end

    reg clk = 0;
    always begin
        #5 clk <= ~clk;
    end

    wire y;

    top top(
        .clk(clk), .ena(1'b1), .y(y)
    );

endmodule

