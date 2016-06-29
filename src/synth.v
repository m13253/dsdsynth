module synth(
    input clk,
    input rst0,
    input rst1,
    input rst2,
    input rst3,
    input [6:0] key0,
    input [6:0] key1,
    input [6:0] key2,
    input [6:0] key3,
    output signed [15:0] pcm
);
    reg signed [7:0] cycle [63:0];
    initial
        $readmemh("../sample/cycle.hex", cycle);
    reg [6:0] env [63:0];
    initial
        $readmemh("../sample/env.hex", env);
    reg [15:0] tune [127:0];
    initial
        $readmemh("../sample/tune.hex", tune);

    genvar i;

    reg [1:0] clkd = 0;
    always @(posedge clk)
        clkd <= clkd + 1;
    reg [3:0] clks = 4'b0001;
    always @(posedge clk)
        clks <= {clks[2:0], clks[3]};

    wire rsts [3:0];
    assign rsts[0] = rst0;
    assign rsts[1] = rst1;
    assign rsts[2] = rst2;
    assign rsts[3] = rst3;
    wire [6:0] keys [3:0];
    assign keys[0] = key0;
    assign keys[1] = key1;
    assign keys[2] = key2;
    assign keys[3] = key3;

    reg [5:0] cyccnt [3:0];
    reg [15:0] cycdiv [3:0];
    generate
        for(i = 0; i < 4; i = i+1) begin : cyc_for
            always @(posedge clks[i], posedge rsts[i]) begin
                if(rsts[i])
                    cycdiv[i] <= tune[keys[i]];
                else if(cycdiv[i] == 0)
                    cycdiv[i] <= tune[keys[i]];
                else
                    cycdiv[i] <= cycdiv[i]-1;
                if(rsts[i])
                    cyccnt[i] <= 0;
                else if(cycdiv[i] == 0)
                    cyccnt[i] <= cyccnt[i]+1;
            end
        end
    endgenerate

    reg [5:0] envcnt [3:0];
    reg [16:0] envdiv [3:0];
    generate
        for(i = 0; i < 4; i = i+1) begin : env_for
            always @(posedge clks[i], posedge rsts[i]) begin
                if(rsts[i])
                    envdiv[i] <= 78125;
                else if(envdiv[i] == 0)
                    envdiv[i] <= 78125;
                else
                    envdiv[i] <= envdiv[i]-1;
                if(rsts[i])
                    envcnt[i] <= 0;
                else if(envdiv[i] == 0)
                    envcnt[i] <= envcnt[i] == 63 ? 63 : envcnt[i]+1;
            end
        end
    endgenerate

    reg signed [7:0] cyci;
    reg signed [7:0] envi;
    wire signed [15:0] pcmi = cyci * envi;
    always @(negedge clk) begin
        cyci <= cycle[cyccnt[clkd]];
        envi <= {1'b0, env[envcnt[clkd]]};
    end

    reg signed [15:0] pcms [3:0];
    generate
        for(i = 0; i < 4; i = i+1) begin : pcms_for
            always @(negedge clks[i])
                pcms[i] <= pcmi;
        end
    endgenerate

    wire [5:0] cyccnt0 = cyccnt[0];
    wire [15:0] cycdiv0 = cycdiv[0];
    wire [5:0] envcnt0 = envcnt[0];
    wire [16:0] envdiv0 = envdiv[0];
    wire signed [15:0] pcm0 = pcms[0];

    assign pcm = $signed(pcms[0] + pcms[1] + pcms[2] + pcms[3]) >>> 1;
endmodule
