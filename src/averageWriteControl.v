module averageWriteControl(
    input [5:0] i_opcode,
    output reg [15:0] o_selWrite
);
always @(*) begin
    case (i_opcode)
        6'd32: o_selWrite = 16'b0000_0000_0000_0111; 
        6'd33: o_selWrite = 16'b0000_0000_0011_1000;
        6'd34: o_selWrite = 16'b0000_0001_1100_0000;
        6'd35: o_selWrite = 16'b0000_1110_0000_0000;
        6'd36: o_selWrite = 16'b0111_0000_0000_0000;
        6'd37: o_selWrite = 16'b1000_0000_0000_0000;
        default: o_selWrite = 16'b0000_0000_0000_0000;
    endcase
end
endmodule