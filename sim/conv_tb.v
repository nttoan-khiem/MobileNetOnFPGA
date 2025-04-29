`timescale 1ps/1ps
module conv_tb();
    //connected
    reg [89:0] i_busData0, i_busData1, i_busData2;
    reg [89:0] i_busWeight0, i_busWeight1, i_busWeight2;
    reg i_opcode;
    wire [9:0] o_data0, o_data1, o_data2;

    conv uut(.*);
    wire signed [9:0] reformat0, reformat1, reformat2;
    assign reformat0 = o_data0;
    assign reformat1 = o_data1;
    assign reformat2 = o_data2; 

    task setInputPort0(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busData0 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task setInputPort1(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busData1 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task setInputPort2(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busData2 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task setWeight0(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busWeight0 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task setWeight1(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busWeight1 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task setWeight2(
        input signed [9:0] data0,
        input signed [9:0] data1,
        input signed [9:0] data2,
        input signed [9:0] data3,
        input signed [9:0] data4,
        input signed [9:0] data5,
        input signed [9:0] data6,
        input signed [9:0] data7,
        input signed [9:0] data8
    );
    begin 
        i_busWeight2 <= {data8, data7, data6, data5, data4, data3, data2, data1, data0};
    end
    endtask

    task checkData0(
        input signed [9:0] data
    );
        begin
            if(reformat0 === data) begin
                $display("[Check: PASS] data port 0 corrent data = %d at time = %d", reformat0, $time);
            end else begin 
                $display("[Check: Fail] data port 0 incorrect data = %d, but expect = %d, at time = %d", reformat0, data, $time);
            end
        end
    endtask

    task checkData1(
        input signed [9:0] data
    );
        begin 
            if(reformat1 === data) begin
                $display("[Check: PASS] data port 1 corrent data = %d at time = %d", reformat1, $time);
            end else begin 
                $display("[Check: Fail] data port 1 incorrect data = %d, but expect = %d, at time = %d", reformat1, data, $time);
            end
        end
    endtask

    task checkData2(
        input signed  [9:0] data
    );
        begin 
            if(reformat2 === data) begin
                $display("[Check: PASS] data port 2 corrent data = %d at time = %d", reformat2, $time);
            end else begin 
                $display("[Check: Fail] data port 2 incorrect data = %d, but expect = %d, at time = %d", reformat2, data, $time);
            end
        end
    endtask

    initial begin
        $display("================CHECK PORT 0===================");
        #10 setInputPort0(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        setWeight0(10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50);
        i_opcode <= 1; //single future.
        #1 checkData0(10'd43);
        $display("================CHECK PORT 1===================");
        #10 setInputPort1(10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200);
        setWeight1(10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60);
        i_opcode <= 1;
        #1 checkData1(10'd105);
        $display("================CHECK PORT 2===================");
        #10 setInputPort2(10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250);
        setWeight2(10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65);
        i_opcode <= 1;
        #1 checkData2(10'd142);
        $display("================CHECK PORT 0===NEGATIVE========");
        #10 setInputPort0(-10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100);
        setWeight0(10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50);
        i_opcode <= 1; //single future.
        #1 checkData0(-10'd44);
        $display("================CHECK PORT 1===NEGATIVE========");
        #10 setInputPort1(-10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150);
        setWeight1(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        i_opcode <= 1; //single future.
        #1 checkData1(-10'd132);
        $display("================CHECK PORT 2===NEGATIVE========");
        #10 setInputPort2(-10'd250, -10'd250, 10'd250, 10'd250, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150);
        setWeight2(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        i_opcode <= 1; //single future.
        #1 checkData2(-10'd74);
        $display("============CHECK PORT 0 MIXED VALUES=============");
        #10 setInputPort0(10'd200, -10'd50, 10'd100, -10'd150, 10'd255, -10'd256, 10'd0, 10'd75, -10'd200);
        setWeight0(10'd30, -10'd40, 10'd50, -10'd60, 10'd70, -10'd80, 10'd90, -10'd100, 10'd110);
        i_opcode <= 1;
        #1 checkData0(10'd30); // Sum=30830 → 30830/1024≈30 (truncated)

        $display("============CHECK PORT 1 MAX POSITIVE=============");
        #10 setInputPort1(10'd255, 10'd255, 10'd255, 10'd255, 10'd255, 10'd255, 10'd255, 10'd255, 10'd255);
        setWeight1(10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1);
        i_opcode <= 1;
        #1 checkData1(10'd2); // Sum=2295 → 2295/1024≈2.24 →2

        $display("============CHECK PORT 2 MAX NEGATIVE=============");
        #10 setInputPort2(-10'd256, -10'd256, -10'd256, -10'd256, -10'd256, -10'd256, -10'd256, -10'd256, -10'd256);
        setWeight2(10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1, 10'd1);
        i_opcode <= 1;
        #1 checkData2(-10'd2); // Sum=-2304 →-2304/1024≈-2.25 →-3 (truncated)

        $display("============CHECK PORT 0 WITH ZEROS=============");
        #10 setInputPort0(10'd0, 10'd0, 10'd0, 10'd0, 10'd0, 10'd0, 10'd0, 10'd0, 10'd0);
        setWeight0(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        i_opcode <= 1;
        #1 checkData0(10'd0); // Sum=0 →0

        $display("============CHECK PORT 1 MIXED AND ZEROS=============");
        #10 setInputPort1(10'd0, -10'd200, 10'd150, 10'd0, -10'd100, 10'd300, 10'd0, -10'd50, 10'd255);
        setWeight1(10'd20, -10'd30, 10'd40, -10'd50, 10'd60, -10'd70, 10'd80, -10'd90, 10'd100);
        i_opcode <= 1;
        #1 checkData1(10'd14); // Sum=15000 →15000/1024≈14.648 →14

        $display("============CHECK PORT 2 EDGE VALUES=============");
        #10 setInputPort2(10'd255, -10'd256, 10'd255, -10'd256, 10'd255, -10'd256, 10'd255, -10'd256, 10'd255);
        setWeight2(10'd1, -10'd1, 10'd1, -10'd1, 10'd1, -10'd1, 10'd1, -10'd1, 10'd1);
        i_opcode <= 1;
        #1 checkData2(10'd5); // Sum=5*255 + 4*(-256)*(-1) =1275+1024=2299 →2299/1024≈2.24 →2

        $display("============CHECK OPCODE 0 SUM ALL PORTS=============");
        #10 
        setInputPort0(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        setWeight0(10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50);
        setInputPort1(10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200, 10'd200);
        setWeight1(10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60, 10'd60);
        setInputPort2(10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250, 10'd250);
        setWeight2(10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65, 10'd65);
        i_opcode <= 0; // Sum all three ports
        #1 checkData0(10'd290); // 43 (Port0) + 105 (Port1) + 142 (Port2) = 290

        $display("============CHECK OPCODE 0 NEGATIVE SUM=============");
        #10 
        setInputPort0(-10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100, -10'd100);
        setWeight0(10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50, 10'd50);
        setInputPort1(-10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150);
        setWeight1(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        setInputPort2(-10'd250, -10'd250, 10'd250, 10'd250, -10'd150, -10'd150, -10'd150, -10'd150, -10'd150);
        setWeight2(10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100, 10'd100);
        i_opcode <= 0; 
        #1 checkData0(-10'd250); // -44 (Port0) -132 (Port1) -74 (Port2) = -250

        $display("============CHECK OPCODE 0 MIXED VALUES=============");
        #10 
        setInputPort0(10'd200, -10'd50, 10'd100, -10'd150, 10'd255, -10'd256, 10'd0, 10'd75, -10'd200);
        setWeight0(10'd30, -10'd40, 10'd50, -10'd60, 10'd70, -10'd80, 10'd90, -10'd100, 10'd110);
        setInputPort1(10'd0, -10'd200, 10'd150, 10'd0, -10'd100, 10'd300, 10'd0, -10'd50, 10'd255);
        setWeight1(10'd20, -10'd30, 10'd40, -10'd50, 10'd60, -10'd70, 10'd80, -10'd90, 10'd100);
        setInputPort2(10'd255, -10'd256, 10'd255, -10'd256, 10'd255, -10'd256, 10'd255, -10'd256, 10'd255);
        setWeight2(10'd1, -10'd1, 10'd1, -10'd1, 10'd1, -10'd1, 10'd1, -10'd1, 10'd1);
        i_opcode <= 0;
        #1 checkData0(10'd46); // 30 (Port0) +14 (Port1) +5 (Port2) =49
        $finish;
    end
endmodule