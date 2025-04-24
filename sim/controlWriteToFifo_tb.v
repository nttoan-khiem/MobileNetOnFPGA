`timescale 1ns/1ns
module controlWriteToFifo_tb();
    // Inputs
    reg i_clk;
    reg i_reset;
    reg i_get;
    reg [9:0] i_xIndex;
    reg [9:0] i_yIndex;
    
    // Outputs
    wire o_eWriteFifo, o_complete, o_process;
    
    // Instantiate the DUT
    controlWriteToFifo dut (
        .i_xIndex(i_xIndex),
        .i_yIndex(i_yIndex),
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_get(i_get),
        .o_eWriteFifo(o_eWriteFifo),
        .o_complete(o_complete),
        .o_process(o_process)
    );
    
    // Generate 100 MHz clock (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end
    
    // Initialize signals and reset
    initial begin
        i_reset = 0; // Active-low reset
        i_get = 0;
        i_xIndex = 1; // Start at x=1
        i_yIndex = 0;
        #20 i_reset = 1; // Release reset after 20ns
    end
    
    // Simulate i_xIndex (1 to 320) and i_yIndex (0 to 239)
    always @(posedge i_clk) begin
        if (i_reset) begin
            if (i_xIndex == 320) begin
                i_xIndex <= 0;
                i_yIndex <= (i_yIndex == 239) ? 0 : i_yIndex + 1;
            end else begin
                i_xIndex <= i_xIndex + 1;
            end
        end
    end
    
    // Trigger i_get at x=0, y=0 (force indices to 0 temporarily)
    initial begin
        #100; // Wait for reset to settle
        // Force x=0, y=0 and assert i_get
        i_get = 1;
        @(posedge o_process); 
        #10
        i_get = 0;
        // Restore x to 1 and continue
        #0931435 $finish; // End simulation after 5000ns
    end
    
    // Monitor outputs
    always @(posedge i_clk) begin
        $display("Time=%0tns | X=%0d, Y=%0d | Get=%b | WriteEn=%b, Complete=%b, Process=%b",
            $time, i_xIndex, i_yIndex, i_get, o_eWriteFifo, o_complete, o_process);
    end
endmodule