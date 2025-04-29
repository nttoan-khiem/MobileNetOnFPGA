`timescale 1ns/1ns
module masterControl_tb();
    // Inputs
    reg i_clk;
    reg i_reset;
    reg i_finish_cam, i_finish_fet, i_finish_conv, i_finish_writeBack, i_finish_ave;
    
    // Outputs
    wire o_startCam, o_startFet, o_startConvolution, o_startAve, o_startWriteBack, o_wrActiveCam, o_opConv;
    wire o_rdActiveConvolution;
    wire [5:0] o_opcode;
    
    // Instantiate DUT
    masterControl dut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_finish_cam(i_finish_cam),
        .i_finish_fet(i_finish_fet),
        .i_finish_conv(i_finish_conv),
        .i_finish_writeBack(i_finish_writeBack),
        .i_finish_ave(i_finish_ave),
        .o_startCam(o_startCam),
        .o_startFet(o_startFet),
        .o_startConvolution(o_startConvolution),
        .o_startAve(o_startAve),
        .o_startWriteBack(o_startWriteBack),
        .o_wrActiveCam(o_wrActiveCam),
        .o_opConv(o_opConv),
        .o_rdActiveConvolution(o_rdActiveConvolution),
        .o_opcode(o_opcode)
    );
    
    // Clock generation (100 MHz)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10ns period
    end
    
    // Reset initialization
    initial begin
        i_reset = 0; // Active-low reset
        #20 i_reset = 1; // Deassert after 20ns
    end
    
    // Simulate finish signals with realistic delays
    // Camera finish
    always @(posedge i_clk) begin
        if(o_startCam) begin 
            $display("| with opcode = %d | write priority CAM = %b | at time =%d | [Cam start signal on] " ,o_opcode, o_wrActiveCam, $time);
            #3000 i_finish_cam = 1;
            $display("| with opcode = %d | at time = %d | [Cam complete] " ,o_opcode, $time);
            #10 i_finish_cam = 0;
        end
    end
    
    // Fetch finish
    always @(posedge i_clk) begin
        if(o_startFet) begin 
            $display("| with opcode = %d | at time = %d | [Fetching start]", o_opcode, $time);
            #250 i_finish_fet = 1;
            $display("| with opcode = %d | at time = %d | [Fetching complete] ", o_opcode, $time);
            #10 i_finish_fet = 0;
        end
    end
    
    // Convolution finish
    always @(posedge i_clk) begin
        if(o_startConvolution) begin 
            $display("| with opcode = %d | opcode convolution= %b | priority read RAM for convolution = %b | at time = %d | [convolution start] ", o_opcode, o_opConv, o_rdActiveConvolution, $time);
            #300 i_finish_conv = 1;
            $display("| with opcode = %d | at time = %d | [convolution complete] ", o_opcode, $time);
            #10 i_finish_conv = 0;
        end
    end
    
    // Write-back finish
    always @(posedge i_clk) begin
        if(o_startWriteBack) begin
            $display("| with opcode = %d | at time = %d | write priority CAM = %b | [WriteBack start] ", o_opcode, $time, o_wrActiveCam);
            #270 i_finish_writeBack = 1;
            $display("| with opcode = %d | at time = %d | [WriteBack complete] ", o_opcode, $time);
            #10 i_finish_writeBack = 0;
        end
    end
    
    // Average finish
    always @(posedge i_clk) begin
        if(o_startAve) begin
            $display("| with opcode = %d | opcode convolution= %b | priority read RAM for convolution = %b | at time = %d | [Average compute start] ", o_opcode, o_opConv, o_rdActiveConvolution, $time);
            #180 i_finish_ave = 1;
            $display("| with opcode = %d | at time = %d | [Average compute complete] ", o_opcode, $time);
            #10 i_finish_ave = 0;
        end
    end
    
    
    // Automatic termination
    initial begin
        wait(o_opcode == 6'd37 && dut.state_q == 5'd21); // Wait for final state
        #1000;
        $display("All 38 operations completed 1 frame successfully!");
        $finish;
    end
    
    // Fallback timeout
    initial begin
        #5000000; // 500µs timeout
        $display("Simulation timeout!");
        $finish;
    end
endmodule