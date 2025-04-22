module mask(
    input i_mask,
    input [89:0] i_data,
    output [89:0] o_data
);
assign o_data[9:0] = i_data[9:0]; 
assign o_data[19:0] = {10{i_mask}} & i_data[19:0]; 
assign o_data[29:0] = {10{i_mask}} & i_data[29:0]; 
assign o_data[39:0] = {10{i_mask}} & i_data[39:0]; 
assign o_data[49:0] = {10{i_mask}} & i_data[49:0]; 
assign o_data[59:0] = {10{i_mask}} & i_data[59:0]; 
assign o_data[69:0] = {10{i_mask}} & i_data[69:0]; 
assign o_data[79:0] = {10{i_mask}} & i_data[79:0]; 
assign o_data[89:0] = {10{i_mask}} & i_data[89:0]; 

endmodule