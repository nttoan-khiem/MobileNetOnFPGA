module writeBackControl_tb();
    // Inputs
    reg i_clk;
    reg i_reset;
    reg i_sdramReady;
    reg i_start;
    reg [18:0] i_baseAddr0 = 19'd00000;  // Test base addresses
    reg [18:0] i_baseAddr1 = 19'd10000;
    reg [18:0] i_baseAddr2 = 19'd20000;
    
    // Outputs
    wire [18:0] o_addrToRam0, o_addrToRam1, o_addrToRam2;
    wire o_quickRam;
    wire [18:0] o_addrToSdram;
    wire o_wrSdram;
    wire [1:0] o_selData;
    wire o_finish;
    
    // Instantiate DUT
    writeBackControl dut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_sdramReady(i_sdramReady),
        .i_baseAddr0(i_baseAddr0),
        .i_baseAddr1(i_baseAddr1),
        .i_baseAddr2(i_baseAddr2),
        .i_start(i_start),
        .o_addrToRam0(o_addrToRam0),
        .o_addrToRam1(o_addrToRam1),
        .o_addrToRam2(o_addrToRam2),
        .o_quickRam(o_quickRam),
        .o_addrToSdram(o_addrToSdram),
        .o_wrSdram(o_wrSdram),
        .o_selData(o_selData),
        .o_finish(o_finish)
    );
    
    // Generate 100MHz clock (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end
    
    // Simulate SDRAM ready signal (3-cycle latency)
    always @(posedge o_wrSdram) begin
        #30 i_sdramReady = 1;  // Assert after 1.5 clock cycles
        #10 i_sdramReady = 0;  // Hold for 1 cycle
    end
    
    // Initialize and reset
    initial begin
        i_reset = 0;  // Active-low reset
        i_start = 0;
        #20 i_reset = 1;  // Release reset
        #10 i_start = 1;  // Start operation
        #10 i_start = 0;
    end
    
    // Monitor signals
    always @(posedge i_clk) begin
        if(o_quickRam) begin 
            $display("Time=%0tns | [read quick RAM0, 1, 2] | at address0 = %d | addr1 = %d | addr2 = %d",
            $time, o_addrToRam0, o_addrToRam1, o_addrToRam2);
        end else if(o_wrSdram) begin 
            if(o_selData == 2'd0) begin
                $display("Time=%0tns | [write RAM 0 to SDRAM] | at address = %d",
                $time, o_addrToSdram); 
            end else if(o_selData == 2'd1) begin 
                $display("Time=%0tns | [write RAM 1 to SDRAM] | at address = %d",
                $time, o_addrToSdram);
            end else if(o_selData == 2'd2) begin 
                $display("Time=%0tns | [write RAM 2 to SDRAM] | at address = %d",
                $time, o_addrToSdram);
            end
        end
    end
    // Stop simulation after completion
    initial begin
        @(posedge o_finish);
        #10;
        $display("Simulation completed.");
        $finish;
    end
endmodule