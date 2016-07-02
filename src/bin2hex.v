module bin2hex(
    input [3:0] bin,
    output reg [7:0] hex
);
    always @(bin)
        case(bin)
            4'h0: hex <= 7'h30;
            4'h1: hex <= 7'h31;
            4'h2: hex <= 7'h32;
            4'h3: hex <= 7'h33;
            4'h4: hex <= 7'h34;
            4'h5: hex <= 7'h35;
            4'h6: hex <= 7'h36;
            4'h7: hex <= 7'h37;
            4'h8: hex <= 7'h38;
            4'h9: hex <= 7'h39;
            4'ha: hex <= 7'h61;
            4'hb: hex <= 7'h62;
            4'hc: hex <= 7'h63;
            4'hd: hex <= 7'h64;
            4'he: hex <= 7'h65;
            4'hf: hex <= 7'h66;
        endcase
endmodule
