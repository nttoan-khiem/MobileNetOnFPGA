module conv(
    input [89:0] i_busData0,
    input [89:0] i_busData1,
    input [89:0] i_busData2,
    input [89:0] i_busWeight0,
    input [89:0] i_busWeight1,
    input [89:0] i_busWeight2,
    input        i_opcode,
    output [9:0] o_data0,
    output [9:0] o_data1,
    output [9:0] o_data2
);
//internal wire connect result of coreConv block
wire [9:0] result [2:0];
wire [19:0] data20_0, data20_1, data20_2;
//architechture
coreConv coreBlock0(.i_data(i_busData0), .i_weight(i_busWeight0), .o_data20(data20_0), .o_data(result[0]));
coreConv coreBlock1(.i_data(i_busData1), .i_weight(i_busWeight1), .o_data20(data20_1), .o_data(result[1]));
coreConv coreBlock2(.i_data(i_busData2), .i_weight(i_busWeight2), .o_data20(data20_2), .o_data(result[2]));
//plus to handel CONV operation
wire [9:0] resultConv;
plus3para plus3paraBlock(.i_data0(data20_0), .i_data1(data20_1), .i_data2(data20_2), .o_data(resultConv));
//assign output
mux2to1 mux2to1Block(.i_dataA(resultConv), .i_dataB(result[0]), .i_sel(i_opcode), .o_data(o_data0));
assign o_data1 = result[1];
assign o_data2 = result[2]; 
endmodule

module plus3para(
    input [19:0] i_data0,
    input [19:0] i_data1,
    input [19:0] i_data2,
    output [9:0] o_data
);
//for high performance
//state 0
wire [19:0] data01;
wire [19:0] dataTemp;
assign data01 = i_data1 + i_data0;
//final state
assign dataTemp = data01 + i_data2;
assign o_data = dataTemp[18:9];
endmodule