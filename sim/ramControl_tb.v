`timescale 1ps/1ps

module ramControl_tb();
//connected
reg [108:0] i_addrOut;
reg [11:0] i_addrIn;
reg [9:0] i_data;
reg [11:0] i_addrOutQuick;
reg        i_quickGet;
reg i_wrEnable, i_clk, i_reset, i_start;
wire [89:0] o_data;
wire [9:0] o_quickData;
wire o_valid, o_ready;
//Task using to test
task writeData(     //write data case
    input [11:0] addr,
    input [9:0] data
);
    begin 
        @(negedge i_clk);
        i_wrEnable <= 1; //enable write to mem
        i_addrIn <= addr;
        i_data <= data;
        @(posedge i_clk);
        #1 $display("[OPERATION] Write data = %d, at address = %d, at time: %d", data, addr, $time); 
    end
endtask

task readDataCheck(
    input [11:0] addr0,
    input [11:0] addr1,
    input [11:0] addr2,
    input [11:0] addr3,
    input [11:0] addr4,
    input [11:0] addr5,
    input [11:0] addr6,
    input [11:0] addr7,
    input [11:0] addr8,
    input [9:0]  data0,
    input [9:0]  data1,
    input [9:0]  data2,
    input [9:0]  data3,
    input [9:0]  data4,
    input [9:0]  data5,
    input [9:0]  data6,
    input [9:0]  data7,
    input [9:0]  data8
);
    begin 
        if(!o_ready) begin 
            @(posedge o_ready);
        end
        @(negedge i_clk);
        i_addrOut <= {addr8, addr7, addr6, addr5, addr4, addr3, addr2, addr1, addr0};
        i_start <= 1;
        @(posedge i_clk);
        i_start <= 0;
        @(posedge o_valid);
        #1
        if(data0 === o_data[9:0]) begin 
            $display("[READ: PASS] o_data0 = %d, expect = %d, at address= %d, at time=%d", o_data[9:0], data0, addr0, $time);
        end else begin 
            $display("[READ: FAIL] o_data0 = %d, expect = %d, at address= %d, at time=%d", o_data[9:0], data0, addr0, $time);
        end
        if(data1 === o_data[19:10]) begin 
            $display("[READ: PASS] o_data1 = %d, expect = %d, at address= %d, at time=%d", o_data[19:10], data1, addr1, $time);
        end else begin 
            $display("[READ: FAIL] o_data1 = %d, expect = %d, at address= %d, at time=%d", o_data[19:10], data1, addr1, $time);
        end
        if(data2 === o_data[29:20]) begin 
            $display("[READ: PASS] o_data2 = %d, expect = %d, at address= %d, at time=%d", o_data[29:20], data2, addr2, $time);
        end else begin 
            $display("[READ: FAIL] o_data2 = %d, expect = %d, at address= %d, at time=%d", o_data[29:20], data2, addr2, $time);
        end
        if(data3 === o_data[39:30]) begin 
            $display("[READ: PASS] o_data3 = %d, expect = %d, at address= %d, at time=%d", o_data[39:30], data3, addr3, $time);
        end else begin 
            $display("[READ: FAIL] o_data3 = %d, expect = %d, at address= %d, at time=%d", o_data[39:30], data3, addr3, $time);
        end
        if(data4 === o_data[49:40]) begin 
            $display("[READ: PASS] o_data4 = %d, expect = %d, at address= %d, at time=%d", o_data[49:40], data4, addr4, $time);
        end else begin 
            $display("[READ: FAIL] o_data4 = %d, expect = %d, at address= %d, at time=%d", o_data[49:40], data4, addr4, $time);
        end
        if(data5 === o_data[59:50]) begin 
            $display("[READ: PASS] o_data5 = %d, expect = %d, at address= %d, at time=%d", o_data[59:50], data5, addr5, $time);
        end else begin 
            $display("[READ: FAIL] o_data5 = %d, expect = %d, at address= %d, at time=%d", o_data[59:50], data5, addr5, $time);
        end
        if(data6 === o_data[69:60]) begin 
            $display("[READ: PASS] o_data6 = %d, expect = %d, at address= %d, at time=%d", o_data[69:60], data6, addr6, $time);
        end else begin 
            $display("[READ: FAIL] o_data6 = %d, expect = %d, at address= %d, at time=%d", o_data[69:60], data6, addr6, $time);
        end
        if(data7 === o_data[79:70]) begin 
            $display("[READ: PASS] o_data7 = %d, expect = %d, at address= %d, at time=%d", o_data[79:70], data7, addr7, $time);
        end else begin 
            $display("[READ: FAIL] o_data7 = %d, expect = %d, at address= %d, at time=%d", o_data[79:70], data7, addr7, $time);
        end
        if(data8 === o_data[89:80]) begin 
            $display("[READ: PASS] o_data8 = %d, expect = %d, at address= %d, at time=%d", o_data[89:80], data8, addr8, $time);
        end else begin 
            $display("[READ: FAIL] o_data8 = %d, expect = %d, at address= %d, at time=%d", o_data[89:80], data8, addr8, $time);
        end
    end
endtask

task checkQuick(
    input [9:0] expect
);
    begin 
        if(o_quickData === expect) begin
            $display("[READ-QUICK : PASS] o_quickData = %d, address = %d, at time: %d", o_quickData, i_addrOutQuick, $time);
        end else begin 
            $display("[READ-QUICK : FAIL] o_quickData = %d, but expect = %d, address = %d, at time: %d", o_quickData, expect, i_addrOutQuick, $time);
        end
    end
endtask

ramControl utt(.*);

initial begin
    i_clk <= 0;
    forever begin
        #5 i_clk <= ~i_clk;
    end
end

initial begin
    i_reset <= 1;
    i_quickGet <= 0;
    #12 i_reset <= 0;
    #26 i_reset <= 1;
    writeData(0, 0);
    writeData(1, 1);
    writeData(2, 2);
    writeData(3, 3);
    writeData(4, 4);
    writeData(5, 5);
    writeData(6, 6);
    writeData(7, 7);
    writeData(8, 8);
    #127
    readDataCheck(0,1,2,3,4,5,6,7,8,0,1,2,3,4,5,6,7,8);
    #28
    writeData(10, 20);
    writeData(11, 21);
    writeData(12, 22);
    writeData(13, 23);
    writeData(14, 24);
    writeData(15, 25);
    writeData(16, 26);
    writeData(17, 27);
    writeData(18, 28);
    #21
    readDataCheck(10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,26,27,28);
    #234
    writeData(0, 21);
    writeData(1, 12);
    writeData(2, 45);
    writeData(3, 34);
    writeData(4, 46);
    writeData(5, 82);
    writeData(6, 42);
    writeData(7, 11);
    writeData(8, 0);
    #12
    readDataCheck(0,1,2,3,4,5,6,7,8,21,12,45,34,46,82,42,11,0);
    #10
    @(negedge i_clk);
    i_quickGet <= 1;
    i_addrOutQuick <= 12'd0;
    @(posedge i_clk);
    #1 checkQuick(21);
    i_addrOutQuick <= 12'd1;
    @(posedge i_clk);
    #1 checkQuick(12);
    $finish;
end
endmodule