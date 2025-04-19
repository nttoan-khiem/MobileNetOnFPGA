module paddingControl(
    input [11:0] i_localAddr,
    output o_sel0,
    output o_sel1,
    output o_sel2,
    output o_sel3,
    output o_sel4,
    output o_sel5,
    output o_sel6,
    output o_sel7,
    output o_sel8
);
wire hHigh, hLow, lHigh, lLow;
assign hHigh = &(i_localAddr[11:6]);
assign hLow = ~(|(i_localAddr[11:6]));
assign lHigh = &(i_localAddr[5:0]);
assign lLow = ~(|(i_localAddr[5:0]));

assign o_sel0 = hLow | lLow;
assign o_sel1 = hLow;
assign o_sel2 = hLow | lHigh;
assign o_sel3 = lLow;
assign o_sel4 = 1'd0;
assign o_sel5 = lHigh;
assign o_sel6 = lLow | hHigh;
assign o_sel7 = hHigh;
assign o_sel8 = hHigh | lLow;
endmodule