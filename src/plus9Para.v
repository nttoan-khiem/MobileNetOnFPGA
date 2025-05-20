module plus9Para(
    input [19:0] i_data0,    
    input [19:0] i_data1,
    input [19:0] i_data2,
    input [19:0] i_data3,
    input [19:0] i_data4,
    input [19:0] i_data5,
    input [19:0] i_data6,
    input [19:0] i_data7,
    input [19:0] i_data8,
    output [19:0] o_data    
);
//for high perfomance
//internal wire level 0
wire [19:0] data01, data32, data54, data76;
assign data01 = i_data0 + i_data1;
assign data32 = i_data2 + i_data3;
assign data54 = i_data4 + i_data5;
assign data76 = i_data6 + i_data7;

//internal wire level 1
wire [19:0] data30, data74;
assign data30 = data01 + data32;
assign data74 = data54 + data76;

//internal wire level 2
wire [19:0] data70;
assign data70 = data30 + data74;

//final state output
wire [19:0] dataTemp;
assign dataTemp = data70 + i_data8;

assign o_data = dataTemp;
endmodule