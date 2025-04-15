module mux2to1(
    input [9:0] i_dataA,
    input [9:0] i_dataB,
    input       i_sel,
    output [9:0] o_data
);
assign o_data = i_sel ? i_dataB : i_dataA;
endmodule