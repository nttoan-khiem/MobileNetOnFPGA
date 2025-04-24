//incomplete
module registerAverage(
    input i_clk,
    input i_reset,
    input i_enableWrite,
    input [15:0] i_selWrite,
    input [9:0] i_data0,
    input [9:0] i_data1,
    input [9:0] i_data2,
    output [159:0] o_ave
);
reg [9:0] register [0:15];
always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        register[0] <= 10'd0;
        register[1] <= 10'd0;
        register[2] <= 10'd0;
        register[3] <= 10'd0;
        register[4] <= 10'd0;
        register[5] <= 10'd0;
        register[6] <= 10'd0;
        register[7] <= 10'd0;
        register[8] <= 10'd0;
        register[9] <= 10'd0;
        register[10] <= 10'd0;
        register[11] <= 10'd0;
        register[12] <= 10'd0;
        register[13] <= 10'd0;
        register[14] <= 10'd0;
        register[15] <= 10'd0;
    end else begin
        if(i_enableWrite) begin  
            case (i_selWrite)
                16'b0000_0000_0000_0111: begin 
                    register[0] <= i_data0;
                    register[1] <= i_data1;
                    register[2] <= i_data2;
                end 
                16'b0000_0000_0011_1000: begin 
                    register[3] <= i_data0;
                    register[4] <= i_data1;
                    register[5] <= i_data2;
                end
                16'b0000_0001_1100_0000: begin 
                    register[6] <= i_data0;
                    register[7] <= i_data1;
                    register[8] <= i_data2;
                end
                16'b0000_1110_0000_0000: begin 
                    register[9] <= i_data0;
                    register[10] <= i_data1;
                    register[11] <= i_data2;
                end
                16'b0111_0000_0000_0000: begin 
                    register[12] <= i_data0;
                    register[13] <= i_data1;
                    register[14] <= i_data2;
                end
                16'b1000_0000_0000_0000: begin 
                    register[15] <= i_data0;
                end
                default: ;
            endcase
        end
    end
end
assign o_ave = {register[15], 
                register[14],
                register[13],
                register[12],
                register[11],
                register[10],
                register[9],
                register[8],
                register[7],
                register[6],
                register[5],
                register[4],
                register[3],
                register[2],
                register[1],
                register[0]};
endmodule