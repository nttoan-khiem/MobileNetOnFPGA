`timescale 1ns/1ns
module fetchingControl_tb();
    // Inputs
    reg i_clk;
    reg i_reset;
    reg i_sdramReady;
    reg i_start;
    reg [18:0] i_baseAddr0 = 19'd0;      // Test base addresses
    reg [18:0] i_baseAddr1 = 19'd10000;  // 65536 in decimal
    reg [18:0] i_baseAddr2 = 19'd20000;  // 131072 in decimal
    
    // Outputs
    wire o_rdSdram;
    wire [18:0] o_addrToSdram;
    wire o_finish;
    wire o_wrRam0, o_wrRam1, o_wrRam2;
    wire [11:0] o_addrToRam;
    
    // Instantiate DUT
    fetchingControl dut (
        .i_baseAddr0(i_baseAddr0),
        .i_baseAddr1(i_baseAddr1),
        .i_baseAddr2(i_baseAddr2),
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_sdramReady(i_sdramReady),
        .i_start(i_start),
        .o_rdSdram(o_rdSdram),
        .o_addrToSdram(o_addrToSdram),
        .o_finish(o_finish),
        .o_wrRam0(o_wrRam0),
        .o_wrRam1(o_wrRam1),
        .o_wrRam2(o_wrRam2),
        .o_addrToRam(o_addrToRam)
    );
    
    // Generate 100MHz clock (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end
    
    // Simulate SDRAM ready signal
    always @(posedge o_rdSdram) begin
        #30 i_sdramReady = 1; // SDRAM responds after 3 clock cycles
        #10 i_sdramReady = 0;
    end
    
    // Initialize and reset
    initial begin
        i_reset = 0; // Active-low reset
        i_start = 0;
        i_sdramReady = 0;
        #20 i_reset = 1; // Release reset
        #10 i_start = 1; // Start operation
        #10 i_start = 0;
    end

    always @(posedge i_clk) begin
        if(o_rdSdram) begin 
            $display("Time=%0tns | [READ SDRAM] | address SDRAM = %d",
            $time, o_addrToSdram);
        end else if (o_wrRam0) begin 
            $display("Time=%0tns | [Write RAM 0] | address = %d", $time, o_addrToRam);
        end else if (o_wrRam1) begin 
            $display("Time=%0tns | [Write RAM 1] | address = %d", $time, o_addrToRam);
        end else if (o_wrRam2) begin 
            $display("Time=%0tns | [Write RAM 2] | address = %d", $time, o_addrToRam);
        end
    end
    
    // Stop after processing all addresses
    initial begin
        @(posedge o_finish)
        #100;
        $display("Simulation completed.");
        $finish;
    end
endmodule