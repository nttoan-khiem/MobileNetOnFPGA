`timescale 1ps/1ps
module testbench_conv();
reg [9:0] dataSet [0:12287];
reg [9:0] weighBus0 [0:8];
reg [9:0] weighBus1 [0:8];
reg [9:0] weighBus2 [0:8];
wire [9:0] o_data0, o_data1, o_data2;
initial begin
    $display("Init value data and weight, at time: %t", $time);
    $readmemh("picture.hex", dataSet);
    $readmemh("weight0_0.hex", weighBus0);
    $readmemh("weight0_1.hex", weighBus1);
    $readmemh("weight0_2.hex", weighBus2);
    $display("Complete Init value data and weight, at time: %t", $time);
end
reg clk = 0;
initial begin 
    clk <= 0;
    forever begin
        #10 clk <= ~clk;
    end
end
integer i,j;
integer file;
reg [9:0] dataBus0 [0:8];
reg [9:0] dataBus1 [0:8];
reg [9:0] dataBus2 [0:8];
wire [89:0] weighToConv0, weighToConv1, weighToConv2;
assign weighToConv0 = {weighBus0[8], weighBus0[7], weighBus0[6], weighBus0[5], weighBus0[4], weighBus0[3], weighBus0[2], weighBus0[1], weighBus0[0]};
assign weighToConv1 = {weighBus1[8], weighBus1[7], weighBus1[6], weighBus1[5], weighBus1[4], weighBus1[3], weighBus1[2], weighBus1[1], weighBus1[0]};
assign weighToConv2 = {weighBus2[8], weighBus2[7], weighBus2[6], weighBus2[5], weighBus2[4], weighBus2[3], weighBus2[2], weighBus2[1], weighBus2[0]};
wire [89:0] dataToConv0, dataToConv1, dataToConv2;
reg i_opcode;
initial begin
    #100
    i_opcode = 0; //chose plus 3 feautur
    file = $fopen("outputHardware.txt", "w");
    for(i = 0; i < 64; i = i+1) begin 
        for (j=0; j < 64; j = j+1) begin 
            //get data
            @(posedge clk)
            if((i > 0) && (j > 0)) begin 
                dataBus0[0] = dataSet[(i-1)*64+(j-1)];
                dataBus1[0] = dataSet[(i-1)*64+(j-1) + 64*64];
                dataBus1[0] = dataSet[(i-1)*64+(j-1) + 2*64*64];
            end else begin 
                dataBus0[0] = 10'd0;
                dataBus1[0] = 10'd0;
                dataBus2[0] = 10'd0;
            end
            if(i > 0) begin 
                dataBus0[1] = dataSet[(i-1)*64+(j)];
                dataBus1[1] = dataSet[(i-1)*64+(j)+ 64*64];
                dataBus2[1] = dataSet[(i-1)*64+(j)+ 2*64*64];
            end else begin 
                dataBus0[1] = 10'd0;
                dataBus1[1] = 10'd0;
                dataBus2[1] = 10'd0;
            end
            if((i > 0) && (j < 63)) begin 
                dataBus0[2] = dataSet[(i-1)*64+(j+1)];
                dataBus1[2] = dataSet[(i-1)*64+(j+1)+ 64*64];
                dataBus2[2] = dataSet[(i-1)*64+(j+1)+ 2*64*64];
            end else begin 
                dataBus0[2] = 10'd0;
                dataBus1[2] = 10'd0;
                dataBus2[2] = 10'd0;
            end
            if(j > 0) begin 
                dataBus0[3] = dataSet[(i)*64+(j-1)];
                dataBus1[3] = dataSet[(i)*64+(j-1)+ 64*64];
                dataBus2[3] = dataSet[(i)*64+(j-1)+ 2*64*64];
            end else begin 
                dataBus0[3] = 10'd0;
                dataBus1[3] = 10'd0;
                dataBus2[3] = 10'd0;
            end
            dataBus0[4] = dataSet[(i)*64+(j)];
            dataBus1[4] = dataSet[(i)*64+(j)+ 64*64];
            dataBus2[4] = dataSet[(i)*64+(j)+ 2*64*64];
            if(j < 63) begin 
                dataBus0[5] = dataSet[(i)*64+(j+1)];
                dataBus1[5] = dataSet[(i)*64+(j+1)+ 64*64];
                dataBus2[5] = dataSet[(i)*64+(j+1)+ 2*64*64];
            end else begin 
                dataBus0[5] = 10'd0;
                dataBus1[5] = 10'd0;
                dataBus2[5] = 10'd0;
            end
            if((i < 63) && (j > 0)) begin 
                dataBus0[6] = dataSet[(i+1)*64+(j-1)];
                dataBus1[6] = dataSet[(i+1)*64+(j-1)+ 64*64];
                dataBus2[6] = dataSet[(i+1)*64+(j-1)+ 2*64*64];
            end else begin 
                dataBus0[6] = 10'd0;
                dataBus1[6] = 10'd0;
                dataBus2[6] = 10'd0;
            end
            if(i < 63) begin 
                dataBus0[7] = dataSet[(i+1)*64+(j)];
                dataBus1[7] = dataSet[(i+1)*64+(j)+ 64*64];
                dataBus2[7] = dataSet[(i+1)*64+(j)+ 2*64*64];
            end else begin 
                dataBus0[7] = 10'd0;
                dataBus1[7] = 10'd0;
                dataBus2[7] = 10'd0;
            end
            if((i < 63) && (j < 63)) begin 
                dataBus0[8] = dataSet[(i+1)*64+(j+1)];
                dataBus1[8] = dataSet[(i+1)*64+(j+1)+ 64*64];
                dataBus2[8] = dataSet[(i+1)*64+(j+1)+ 2*64*64];
            end else begin 
                dataBus0[8] = 10'd0;
                dataBus1[8] = 10'd0;
                dataBus2[8] = 10'd0;
            end
            //end get data
            #1
            $display("Result i = %d, j = %d, result = %d", i, j, o_data0);
            $fdisplay(file, "%d", o_data0);
        end
    end
    $fclose(file);
    #10 $finish;
end
assign dataToConv0 = {dataBus0[8], dataBus0[7], dataBus0[6], dataBus0[5], dataBus0[4], dataBus0[3], dataBus0[2], dataBus0[1], dataBus0[0]};
assign dataToConv1 = {dataBus1[8], dataBus1[7], dataBus1[6], dataBus1[5], dataBus1[4], dataBus1[3], dataBus1[2], dataBus1[1], dataBus1[0]};
assign dataToConv2 = {dataBus2[8], dataBus2[7], dataBus2[6], dataBus2[5], dataBus2[4], dataBus2[3], dataBus2[2], dataBus2[1], dataBus2[0]};
conv uut(
    .i_busData0(dataToConv0),
    .i_busData1(dataToConv1),
    .i_busData2(dataToConv2),
    .i_busWeight0(weighToConv0),
    .i_busWeight1(weighToConv1),
    .i_busWeight2(weighToConv2),
    .i_opcode(i_opcode),
    .o_data0(o_data0),
    .o_data1(o_data1),
    .o_data2(o_data2)
);

endmodule