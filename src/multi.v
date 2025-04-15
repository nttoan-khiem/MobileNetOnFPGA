module multi(
    input signed [9:0] i_data,
    input signed [9:0] i_weight,
    output signed [19:0] o_data
);
assign o_data = i_data * i_weight; //using DSP on FPGA for best performance and low power. 
endmodule