module tb_masterControl();
    // Inputs
    reg i_clk;
    reg i_reset;
    reg i_finish_cam, i_finish_fet, i_finish_conv, i_finish_writeBack, i_finish_ave;
    
    // Outputs (connected to DUT)
    wire o_startCam, o_startFet, o_startConvolution, o_startAve, o_startWriteBack, o_wrActiveCam, o_opConv;
    wire [5:0] o_opcode;
    
    // Instantiate the DUT
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
        .o_opcode(o_opcode)
    );
    
    // Clock generation (50 MHz)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10ns period
    end
    
    // Reset initialization
    initial begin
        i_reset = 0; // Assert reset (active-low)
        #20 i_reset = 1; // De-assert after 20ns
    end
    
    // Simulate finish signals with delays
    // Camera finish
    initial begin
        forever begin
            @(posedge o_startCam); // Wait for camera start
            repeat(2) @(posedge i_clk); // Delay 2 cycles
            i_finish_cam = 1;
            @(posedge i_clk);
            i_finish_cam = 0;
        end
    end
    
    // Fetch finish
    initial begin
        forever begin
            @(posedge o_startFet);
            repeat(2) @(posedge i_clk);
            i_finish_fet = 1;
            @(posedge i_clk);
            i_finish_fet = 0;
        end
    end
    
    // Convolution finish
    initial begin
        forever begin
            @(posedge o_startConvolution);
            repeat(2) @(posedge i_clk);
            i_finish_conv = 1;
            @(posedge i_clk);
            i_finish_conv = 0;
        end
    end
    
    // Write-back finish
    initial begin
        forever begin
            @(posedge o_startWriteBack);
            repeat(2) @(posedge i_clk);
            i_finish_writeBack = 1;
            @(posedge i_clk);
            i_finish_writeBack = 0;
        end
    end
    
    // Average finish
    initial begin
        forever begin
            @(posedge o_startAve);
            repeat(2) @(posedge i_clk);
            i_finish_ave = 1;
            @(posedge i_clk);
            i_finish_ave = 0;
        end
    end
    
    // Monitor state and signals
    always @(posedge i_clk) begin
        $strobe("Time = %0t ns: State = %0d, Opcode = %0d | Inputs: cam=%b, fet=%b, conv=%b, wb=%b, ave=%b | Outputs: startCam=%b, startFet=%b, startConv=%b, startAve=%b, startWB=%b, opConv=%b",
            $time, dut.state_q, dut.opcode_q,
            i_finish_cam, i_finish_fet, i_finish_conv, i_finish_writeBack, i_finish_ave,
            o_startCam, o_startFet, o_startConvolution, o_startAve, o_startWriteBack, o_opConv);
    end
    
    // Stop simulation after opcode 37 completes
    initial begin
        #1000; // Max simulation time (adjust as needed)
        $display("Simulation ended.");
        $finish;
    end
endmodule