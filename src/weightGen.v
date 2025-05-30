module weightGen(
    input [5:0] i_opcode,
    output reg [89:0] o_weight0,
    output reg [89:0] o_weight1,
    output reg [89:0] o_weight2
);

//expected to generate ROM
reg [89:0] weight0 [0:31];
reg [89:0] weight1 [0:31];
reg [89:0] weight2 [0:31];

initial begin
    $readmemh("weight0.hex", weight0);
    $readmemh("weight1.hex", weight1);
    $readmemh("weight2.hex", weight2);
end

always @(*) begin
    o_weight0 = weight0[i_opcode];
    o_weight1 = weight1[i_opcode];
    o_weight2 = weight2[i_opcode];
end
endmodule