module coreConv(
    input [89:0] i_data,
    input [89:0] i_weight,
    output [19:0] o_data20,
    output [9:0] o_data
);
//internal wire
wire [19:0] dataTemp;
//i_data de_Bus
wire [9:0] data [8:0];
assign data[0] = i_data[9:0];
assign data[1] = i_data[19:10];
assign data[2] = i_data[29:20];
assign data[3] = i_data[39:30];
assign data[4] = i_data[49:40];
assign data[5] = i_data[59:50];
assign data[6] = i_data[69:60];
assign data[7] = i_data[79:70];
assign data[8] = i_data[89:80];
//i_weight de_bus
wire [9:0] weight [8:0];
assign weight[0] = i_weight[9:0];
assign weight[1] = i_weight[19:10];
assign weight[2] = i_weight[29:20];
assign weight[3] = i_weight[39:30];
assign weight[4] = i_weight[49:40];
assign weight[5] = i_weight[59:50];
assign weight[6] = i_weight[69:60];
assign weight[7] = i_weight[79:70];
assign weight[8] = i_weight[89:80];
//internal wire result of multi 20 bit
wire [19:0] resultMulti [8:0];
//mutiplication block
multi multiBlock_0(.i_data(data[0]), .i_weight(weight[0]), .o_data(resultMulti[0]));
multi multiBlock_1(.i_data(data[1]), .i_weight(weight[1]), .o_data(resultMulti[1]));
multi multiBlock_2(.i_data(data[2]), .i_weight(weight[2]), .o_data(resultMulti[2]));
multi multiBlock_3(.i_data(data[3]), .i_weight(weight[3]), .o_data(resultMulti[3]));
multi multiBlock_4(.i_data(data[4]), .i_weight(weight[4]), .o_data(resultMulti[4]));
multi multiBlock_5(.i_data(data[5]), .i_weight(weight[5]), .o_data(resultMulti[5]));
multi multiBlock_6(.i_data(data[6]), .i_weight(weight[6]), .o_data(resultMulti[6]));
multi multiBlock_7(.i_data(data[7]), .i_weight(weight[7]), .o_data(resultMulti[7]));
multi multiBlock_8(.i_data(data[8]), .i_weight(weight[8]), .o_data(resultMulti[8]));
//Plus block
plus9Para adder9paraBlock(  .i_data0(resultMulti[0]), 
                            .i_data1(resultMulti[1]), 
                            .i_data2(resultMulti[2]), 
                            .i_data3(resultMulti[3]), 
                            .i_data4(resultMulti[4]), 
                            .i_data5(resultMulti[5]), 
                            .i_data6(resultMulti[6]), 
                            .i_data7(resultMulti[7]), 
                            .i_data8(resultMulti[8]), 
                            .o_data(dataTemp)
                        );
assign o_data = dataTemp[18:9];
assign o_data20 = dataTemp;
endmodule