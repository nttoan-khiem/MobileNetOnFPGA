module fullyConnected (
    input              i_clk,
    input              i_reset,
    input              i_enable,
    input  [159:0]     i_data,     // 16 x 10-bit packed inputs
    output reg [31:0]  o_result
);

    // Input unpacking
    wire [9:0] in_data0  = i_data[9:0];
    wire [9:0] in_data1  = i_data[19:10];
    wire [9:0] in_data2  = i_data[29:20];
    wire [9:0] in_data3  = i_data[39:30];
    wire [9:0] in_data4  = i_data[49:40];
    wire [9:0] in_data5  = i_data[59:50];
    wire [9:0] in_data6  = i_data[69:60];
    wire [9:0] in_data7  = i_data[79:70];
    wire [9:0] in_data8  = i_data[89:80];
    wire [9:0] in_data9  = i_data[99:90];
    wire [9:0] in_data10 = i_data[109:100];
    wire [9:0] in_data11 = i_data[119:110];
    wire [9:0] in_data12 = i_data[129:120];
    wire [9:0] in_data13 = i_data[139:130];
    wire [9:0] in_data14 = i_data[149:140];
    wire [9:0] in_data15 = i_data[159:150];

    // Weights
    reg signed [15:0] w0, w1, w2, w3, w4, w5, w6, w7;
    reg signed [15:0] w8, w9, w10, w11, w12, w13, w14, w15;
    reg signed [15:0] w_bias;

    // Sequential multiply-accumulate using pairing
    reg signed [31:0] sum;

    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            o_result <= 0;
        end else if (i_enable) begin
            sum = 0;
            sum = sum +
                $signed(in_data0)  * w0  +
                $signed(in_data1)  * w1;
            sum = sum +
                $signed(in_data2)  * w2  +
                $signed(in_data3)  * w3;
            sum = sum +
                $signed(in_data4)  * w4  +
                $signed(in_data5)  * w5;
            sum = sum +
                $signed(in_data6)  * w6  +
                $signed(in_data7)  * w7;
            sum = sum +
                $signed(in_data8)  * w8  +
                $signed(in_data9)  * w9;
            sum = sum +
                $signed(in_data10) * w10 +
                $signed(in_data11) * w11;
            sum = sum +
                $signed(in_data12) * w12 +
                $signed(in_data13) * w13;
            sum = sum +
                $signed(in_data14) * w14 +
                $signed(in_data15) * w15;
            sum = sum + w_bias;
            o_result <= sum;
        end
    end

endmodule