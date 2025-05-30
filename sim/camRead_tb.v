`timescale 1ns/1ns
module camRead_tb();
    // Inputs
    reg i_pclk;           // Pixel clock
    reg i_vsync;          // Vertical sync
    reg i_href;           // Horizontal reference
    reg [7:0] i_data;     // 8-bit pixel data
    reg i_reset;          // Active-high reset
    
    // Outputs
    wire [15:0] o_pixelOut;
    wire o_pixelValid;
    wire [9:0] o_xIndex;
    wire [9:0] o_yIndex;
    wire o_pixelClk;
    
    // Instantiate the DUT
    cameraRead dut (
        .i_pclk(i_pclk),
        .i_vsync(i_vsync),
        .i_href(i_href),
        .i_data(i_data),
        .i_reset(i_reset),
        .o_pixelOut(o_pixelOut),
        .o_pixelValid(o_pixelValid),
        .o_xIndex(o_xIndex),
        .o_yIndex(o_yIndex),
        .o_pixelClk(o_pixelClk)
    );
    
    // Generate 25 MHz clock (40ns period, typical for OV7670)
    initial begin
        i_pclk = 0;
        forever #20 i_pclk = ~i_pclk; // 40ns period (25 MHz)
    end
    
    // Reset and initialization
    initial begin
        i_reset = 0; // Assert reset (active-high)
        i_vsync = 0;
        i_href = 0;
        i_data = 0;
        #40 i_reset = 1; // Release reset after 40ns
        #1000; // Wait for reset to propagate
        generate_frame(); // Generate one frame (240x320)
        #1000;
        $finish;
    end
    
    // Task to generate a single frame
    task generate_frame;
        integer row, col;
        begin
            // VSYNC pulse to start the frame
            i_vsync = 1;
            #800; // Hold VSYNC high for 2 clock cycles
            i_vsync = 0;
            #500
            // Loop through 320 rows (Y)
            for (row = 0; row < 240; row = row + 1) begin
                // HREF pulse for one row (240 pixels)
                @(negedge i_pclk);
                i_href = 1;
                // Loop through 240 pixels (X)
                for (col = 0; col < 320; col = col + 1) begin
                    // High byte (simulate RGB565 upper 8 bits)
                    @(negedge i_pclk);
                    i_data = col >> 8; // Example: incrementing high byte
                    
                    // Low byte (simulate RGB565 lower 8 bits)
                    @(negedge i_pclk);
                    i_data = col; // Example: incrementing low byte
                end
                // End of row: deassert HREF
                @(negedge i_pclk);
                i_href = 0;
                #500; // Small gap between rows
            end
        end
    endtask
    
    // Monitor outputs
    always @(posedge i_pclk) begin
        $display("Time = %0t ns | X=%0d, Y=%0d | Pixel=%d (Valid=%b)",
            $time, o_xIndex, o_yIndex, o_pixelOut, o_pixelValid);
    end
endmodule