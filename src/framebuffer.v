module framebuffer(
    input clk,
    input [6:0] key0,
    input [6:0] key1,
    input [6:0] key2,
    input [6:0] key3,
    input [10:0] pos,
    output reg [7:0] char
);
    wire [7:0] hex00;
    wire [7:0] hex01;
    wire [7:0] hex10;
    wire [7:0] hex11;
    wire [7:0] hex20;
    wire [7:0] hex21;
    wire [7:0] hex30;
    wire [7:0] hex31;
    bin2hex bin2hex00(key0[6:4], hex00);
    bin2hex bin2hex01(key0[3:0], hex01);
    bin2hex bin2hex10(key1[6:4], hex10);
    bin2hex bin2hex11(key1[3:0], hex11);
    bin2hex bin2hex20(key2[6:4], hex20);
    bin2hex bin2hex21(key2[3:0], hex21);
    bin2hex bin2hex30(key3[6:4], hex30);
    bin2hex bin2hex31(key3[3:0], hex31);
    always @(posedge clk)
        case(pos)
            /* Row 0 */
            0: char <= "M";
            1: char <= "I";
            2: char <= "D";
            3: char <= "I";
            5: char <= "S";
            6: char <= "e";
            7: char <= "q";
            8: char <= "u";
            9: char <= "e";
            10: char <= "n";
            11: char <= "c";
            12: char <= "e";
            13: char <= "r";
            /* Row 2, 3, 4, 5 */
            2*80, 3*80, 4*80, 5*80: char <= "T";
            2*80+1, 3*80+1, 4*80+1, 5*80+1: char <= "r";
            2*80+2, 3*80+2, 4*80+2, 5*80+2: char <= "a";
            2*80+3, 3*80+3, 4*80+3, 5*80+3: char <= "c";
            2*80+4, 3*80+4, 4*80+4, 5*80+4: char <= "k";
            2*80+6: char <= "1";
            3*80+6: char <= "2";
            4*80+6: char <= "3";
            5*80+6: char <= "4";
            2*80+7, 3*80+7, 4*80+7, 5*80+7: char <= ":";
            2*80+9, 3*80+9, 4*80+9, 5*80+9: char <= "0";
            2*80+10, 3*80+10, 4*80+10, 5*80+10: char <= "x";
            /* Note ID */
            2*80+11: char <= hex00;
            2*80+12: char <= hex01;
            3*80+11: char <= hex10;
            3*80+12: char <= hex11;
            4*80+11: char <= hex20;
            4*80+12: char <= hex21;
            5*80+11: char <= hex30;
            5*80+12: char <= hex31;
            default: char <= " ";
        endcase
endmodule
