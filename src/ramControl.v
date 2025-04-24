module ramControl(
    input [107:0]       i_addrOut, //addr read data
    input [11:0]        i_addrIn,
    input [9:0]         i_data,     // Đầu vào dữ liệu
    input               i_wrEnable,
    input               i_quickGet,
    input [11:0]        i_addrOutQuick,
    input               i_clk,
    input               i_reset,
    input               i_start,
    output reg [89:0]   o_data,     // Đầu ra dữ liệu
    output [9:0]    o_quickData,
    output reg          o_valid,
    output reg          o_ready
);
wire [11:0] addrOut [9:0];
assign addrOut[0] = i_addrOut[11:0]; //data0
assign addrOut[1] = i_addrOut[23:12]; //data1, 
assign addrOut[2] = i_addrOut[35:24]; //data2,
assign addrOut[3] = i_addrOut[47:36]; 
assign addrOut[4] = i_addrOut[59:48];
assign addrOut[5] = i_addrOut[71:60];
assign addrOut[6] = i_addrOut[83:72];
assign addrOut[7] = i_addrOut[95:84];
assign addrOut[8] = i_addrOut[107:96]; //data8 
assign addrOut[9] = i_addrOutQuick;
reg [11:0] activeAddr;
localparam [3:0]    idle  = 4'd0,
                    load0 = 4'd1,
                    load1 = 4'd2,       
                    load2 = 4'd3,
                    load3 = 4'd4,
                    load4 = 4'd5,
                    load5 = 4'd6,
                    load6 = 4'd7,
                    load7 = 4'd8,
                    load8 = 4'd9,
                    buffer = 4'd10;

reg [3:0] state_q, state_d;
reg [3:0] selAddr;
reg [8:0] enableWriteBuffer;
wire [9:0] dataFromRamBlock;

always @(*) begin //Mux select address
    activeAddr = addrOut[selAddr];
end

always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        state_q <= idle;
    end else begin 
        state_q <= state_d;
    end
end

always @(*) begin
    case (state_q)
        idle: begin 
            if(i_reset) begin
                if(i_start) begin 
                    state_d = load0;
                    selAddr = 4'd0;
                end else if (i_quickGet) begin 
                    state_d = idle;
                    selAddr = 4'd9;
                end else begin 
                    state_d = idle;
                    selAddr = 4'd0;
                end
            end else begin 
                state_d = idle;
                selAddr = 4'd0;
            end
            o_ready = 1;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0000_0;
        end
        load0: begin 
            state_d = load1;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0000_1;
            selAddr = 4'd1;
        end
        load1: begin 
            state_d = load2;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0001_0;
            selAddr = 4'd2;
        end 
        load2: begin 
            state_d = load3;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0010_0;
            selAddr = 4'd3;
        end
        load3: begin 
            state_d = load4;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0100_0;
            selAddr = 4'd4;
        end
        load4: begin 
            state_d = load5;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_1000_0;
            selAddr = 4'd5;
        end
        load5: begin 
            state_d = load6;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0001_0000_0;
            selAddr = 4'd6;
        end
        load6: begin 
            state_d = load7;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0010_0000_0;
            selAddr = 4'd7;
        end
        load7: begin 
            state_d = load8;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0100_0000_0;
            selAddr = 4'd8;
        end
        load8: begin 
            state_d = buffer;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b1000_0000_0;
            selAddr = 4'd0;
        end
        buffer: begin 
            state_d = idle;
            o_ready = 0;
            o_valid = 1;
            enableWriteBuffer = 9'b0000_0000_0;
            selAddr = 4'd0;
        end
        default: begin 
            state_d = idle;
            o_ready = 0;
            o_valid = 0;
            enableWriteBuffer = 9'b0000_0000_0;
            selAddr = 4'd0;
        end
    endcase
end

ramConv RAMBLOCK(
    .i_addrIn(i_addrIn),   // 12-bit address (4096 locations)
    .i_addrOut(activeAddr),   // 12-bit address (4096 locations)
    .i_data(i_data),   // 10-bit data input
    .i_wrEnable(i_wrEnable),
    .i_clk(i_clk),
    .o_data(dataFromRamBlock)  // 10-bit data output
);

always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        o_data <= 90'd0;
    end else begin 
        case (enableWriteBuffer)
            9'b0000_0000_1: o_data[9:0] <= dataFromRamBlock; 
            9'b0000_0001_0: o_data[19:10] <= dataFromRamBlock; 
            9'b0000_0010_0: o_data[29:20] <= dataFromRamBlock; 
            9'b0000_0100_0: o_data[39:30] <= dataFromRamBlock; 
            9'b0000_1000_0: o_data[49:40] <= dataFromRamBlock; 
            9'b0001_0000_0: o_data[59:50] <= dataFromRamBlock; 
            9'b0010_0000_0: o_data[69:60] <= dataFromRamBlock; 
            9'b0100_0000_0: o_data[79:70] <= dataFromRamBlock; 
            9'b1000_0000_0: o_data[89:80] <= dataFromRamBlock;  
            default: o_data <= o_data;
        endcase
    end
end
assign o_quickData = dataFromRamBlock;
endmodule   