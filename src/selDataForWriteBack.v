module selDataForWriteBack(
    input [1:0]         i_sel,
    input [15:0]        i_data0,
    input [15:0]        i_data1,
    input [15:0]        i_data2,
    output reg [15:0]   o_data
);
always @(*) begin
    case (i_sel)
        2'd0: o_data = i_data0;
        2'd1: o_data = i_data1;
        2'd2: o_data = i_data2; 
        default: o_data = i_data0;
    endcase
end
endmodule