module average(
    input [89:0] i_data,
    input       i_clk,
    input       i_reset,
    output [9:0] o_data
);
reg [21:0] data;
always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        data <= 22'd0;
    end else begin 
        data <= data + i_data[9:0] + i_data[19:10] + i_data[29:20] + i_data[39:30] + i_data[49:40] + i_data[59:50] + i_data[69:60] + i_data[79:70] + i_data[89:80];
    end
end
assign o_data = data[21:12];
endmodule