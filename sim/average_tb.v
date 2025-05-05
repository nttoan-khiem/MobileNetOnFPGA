`timescale 1ns/1ps
module average_tb();
    reg i_clk, i_reset, i_writeAdd;
    reg [89:0] i_data;
    wire [9:0] o_data;

    average uut (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_writeAdd(i_writeAdd),
        .i_data(i_data),
        .o_data(o_data)
    );

    // Clock generation (100MHz)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    // Test procedure
    initial begin
        // Initialize
        $display("-----------------------------------------");
        i_reset = 0;
        i_writeAdd = 0;
        i_data = 0;

        // Reset the module
        #20;
        i_reset = 1;
        #10;

        // Test: Accumulate 64x64 = 4096
        $display("=== TEST 64x64 ACCUMULATION ===");
        // Set i_data to sum 64 per addition (8 + 7*8)
        i_data = {10'd8, {8{10'd8}}}; // 8 + 7*8 = 64
        @ (posedge i_clk);
        i_writeAdd = 1;
        repeat (456) begin
            @(negedge i_clk);   // Deassert after one cycle //it miss first posedge
        end
        i_data <= {10'd8, {8{10'd0}}};
        @(posedge i_clk);
        #1
        // Check result (4096 / 4096 = 1)
        @(posedge i_clk);
        if (o_data === 10'd8) 
            $display("PASS: o_data = 8 (Expected 8)");
        else 
            $display("FAIL: o_data = %d (Expected 8)", o_data);

        $display("-----------------------------------------");
        i_reset = 0;
        i_writeAdd = 0;
        i_data = 0;

        // Reset the module
        #20;
        i_reset = 1;
        #10;

        // Test: Accumulate 64x64 = 4096
        $display("=== TEST 64x64 ACCUMULATION ===");
        // Set i_data to sum 64 per addition (8 + 7*8)
        i_data = {10'd255, {8{10'd200}}}; // 8 + 7*8 = 64
        @ (posedge i_clk);
        i_writeAdd = 1;
        repeat (456) begin
            @(negedge i_clk);   // Deassert after one cycle //it miss first posedge
        end
        i_data <= {10'd255, {8{10'd0}}};
        @(posedge i_clk);
        #1
        // Check result (4096 / 4096 = 1)
        @(posedge i_clk);
        if (o_data === 10'd206) 
            $display("PASS: o_data = %d (Expected 206)", o_data);
        else 
            $display("FAIL: o_data = %d (Expected 206)", o_data);
        $display("-----------------------------------------");
        $finish;
    end
endmodule