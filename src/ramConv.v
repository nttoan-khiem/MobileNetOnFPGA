/*module ramConv(
    input [11:0]   i_addrIn,
    input [108:0]   i_addrOut,
    input [9:0]    i_data,     // Đầu vào dữ liệu riêng
    output [89:0]   o_data,     // Đầu ra dữ liệu riêng
    input           i_wrEnable,
    input           i_clk
);

// Giải đa hợp địa chỉ
wire [11:0] addrIn;
assign addrIn = i_addrIn;


wire [11:0] addrOut [8:0];
assign addrOut[0] = i_addrOut[11:0];
assign addrOut[1] = i_addrOut[23:12];
assign addrOut[2] = i_addrOut[35:24];
assign addrOut[3] = i_addrOut[47:36];
assign addrOut[4] = i_addrOut[59:48];
assign addrOut[5] = i_addrOut[71:60];
assign addrOut[6] = i_addrOut[83:72];
assign addrOut[7] = i_addrOut[95:84];
assign addrOut[8] = i_addrOut[107:96]; 

// Bộ nhớ nội bộ
reg [9:0] mem [4095:0];

// Giải đa hợp dữ liệu đọc
reg [9:0] data [8:0];
always @(posedge i_clk) begin
    data[0] <= mem[addrOut[0]];
    //data[1] <= mem[addrOut[1]];
    //data[2] <= mem[addrOut[2]];
    //data[3] <= mem[addrOut[3]];
    //data[4] <= mem[addrOut[4]];
    //data[5] <= mem[addrOut[5]];
    //data[6] <= mem[addrOut[6]];
    //data[7] <= mem[addrOut[7]];
    //data[8] <= mem[addrOut[8]];
end

// Ghi dữ liệu vào bộ nhớ
always @(posedge i_clk) begin
    if (i_wrEnable) begin 
        mem[addrIn] <= i_data[9:0];   
    end else begin 
        mem[addrIn] <= mem[addrIn];
    end
end

// Đa hợp đầu ra dữ liệu (Không dùng bus ba trạng thái)
assign o_data = (i_wrEnable) ? 90'b0 : {data[8], data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};

endmodule*/


module ramConv (
    input [11:0] i_addrIn,   // 12-bit address (4096 locations)
    input [11:0] i_addrOut,   // 12-bit address (4096 locations)
    input [9:0]  i_data,   // 10-bit data input
    input        i_wrEnable,
    input        i_clk,
    output reg [9:0] o_data  // 10-bit data output
);

    // Declare BRAM and force Quartus to use M10K blocks
    reg [9:0] RAM [0:4095];

    always @(posedge i_clk) begin
        if (i_wrEnable) RAM[i_addrIn] <= i_data; // Write operation
        o_data <= RAM[i_addrOut];
    end

endmodule
