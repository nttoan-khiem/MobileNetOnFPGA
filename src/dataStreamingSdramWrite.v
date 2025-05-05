module dataSteamingSdramWrite(
    input [15:0] i_dataA,
    input [15:0] i_dataB,
    input [18:0] i_addrA,
    input [18:0] i_addrB,
    input i_enableWriteA,
    input i_enableWriteB,
    input i_sel,
    output [15:0] o_data,
    output [18:0] o_addr,
    output o_enableWrite
);
assign o_data = (i_sel) ? i_dataB : i_dataA;
assign o_addr = (i_sel) ? i_addrB : i_addrA;
assign o_enableWrite = (i_sel) ? i_enableWriteB : i_enableWriteA;
endmodule