module cameraRead(
    input  wire         i_pclk,       // Camera pixel clock
    input  wire         i_vsync,      // Vertical sync from camera (start/end of frame)
    input  wire         i_href,       // Horizontal reference (indicates valid pixel i_data in a row)
    input  wire [7:0]   i_data,       // 8-bit pixel i_data from camera
    input  wire         i_reset,        // Active-high synchronous reset

    output reg  [15:0]  o_pixelOut,  // 16-bit pixel i_data in RGB565 format
    output reg          o_pixelValid,// Indicates when o_pixelOut is valid (i.e. after both bytes are received)
    output reg  [9:0]   o_xIndex,    // Horizontal pixel index (adjust bit-width as needed)
    output reg  [9:0]   o_yIndex,    // Vertical pixel index (adjust bit-width as needed)
    output wire         o_pixelClk   // Clock for downstream pixel processing (can be derived from i_pclk)
);

    // Internal state to manage byte pairing from the camera
    // 0 indicates waiting for the high byte, 1 for the low byte
    reg byte_state;

    // Generate a simple pixel clock output.
    // For this example, we simply use the same i_pclk.
    // In a real system you might need to generate or divide clocks differently.
    assign o_pixelClk = i_pclk;

    // Main process: driven by the rising edge of i_pclk
    always @(posedge i_pclk or negedge i_reset) begin
        if (!i_reset) begin
            // Reset all signals
            o_pixelOut   <= 16'd0;
            o_pixelValid <= 1'b0;
            o_xIndex     <= 10'd0;
            o_yIndex     <= 10'd0;
            byte_state  <= 1'b0;
        end else begin
            // Start-of-frame detected: reset row and column counters
            if (i_vsync) begin
                o_xIndex     <= 10'd0;
                o_yIndex     <= 10'd0;
                byte_state  <= 1'b0;
                o_pixelValid <= 1'b0;
            end else if (i_href) begin
                // When i_href is high, the pixel i_data is valid for the current row.
                if (byte_state == 1'b0) begin
                    // Fii_reset byte: store in the high 8 bits of o_pixelOut
                    o_pixelOut[15:8] <= i_data;
                    // Next cycle will capture the low byte.
                    byte_state <= 1'b1;
                    // Do not assert o_pixelValid until the full pixel is available
                    o_pixelValid <= 1'b0;
                end else begin
                    // Second byte: store in the low 8 bits of o_pixelOut
                    o_pixelOut[7:0] <= i_data;
                    // Now the pixel is complete – signal that the pixel is ready
                    o_pixelValid <= 1'b1;
                    // Increment the horizontal index after a full pixel is captured
                    o_xIndex <= o_xIndex + 10'd1;
                    // Reset state for next pixel
                    byte_state <= 1'b0;
                end
            end else begin
                // When i_href is low, we are not receiving valid pixel i_data.
                // If we were in the middle of a pixel (odd byte received), discard it.
                byte_state  <= 1'b0;
                o_pixelValid <= 1'b0;
                
                // End of a line: if o_xIndex is not zero then
                // the transition of i_href to low indicates end-of-line.
                // Update the vertical index and reset horizontal index.
                if (o_xIndex != 0) begin
                    o_xIndex <= 10'd0;
                    o_yIndex <= o_yIndex + 10'd1;
                end
            end
        end
    end

endmodule
