module mask(
    input i_mask,
    input [89:0] i_data,
    output [89:0] o_data
);
assign o_data[9:0] = i_data[9:0]; 
assign o_data[19:10] = {10{i_mask}} & i_data[19:10]; 
assign o_data[29:20] = {10{i_mask}} & i_data[29:20]; 
assign o_data[39:30] = {10{i_mask}} & i_data[39:30]; 
assign o_data[49:40] = {10{i_mask}} & i_data[49:40]; 
assign o_data[59:50] = {10{i_mask}} & i_data[59:50]; 
assign o_data[69:60] = {10{i_mask}} & i_data[69:60]; 
assign o_data[79:70] = {10{i_mask}} & i_data[79:70]; 
assign o_data[89:80] = {10{i_mask}} & i_data[89:80]; 

endmodule