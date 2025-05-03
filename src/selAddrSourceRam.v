module selAddrSourceRam(
    input               i_sel,
    input [107:0]        i_addrConv,
    input [107:0]        i_addrAve,
    input                i_startReadFromConv,
    input                i_startReadFromAve,
    output reg [107:0]   o_addr,
    output reg           o_startRead
);
always @(*) begin
    if(i_sel) begin //rdActiveConvolution
        o_addr = i_addrConv;
        o_startRead = i_startReadFromConv;
    end else begin 
        o_addr = i_addrAve;
        o_startRead = i_startReadFromAve;
    end
end
endmodule