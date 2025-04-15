module spi_master (
    input         i_clk,      // System clock
    input         i_reset,    // Reset (active high)
    input         i_start,    // Start SPI transaction
    input  [7:0]  i_data,     // Data to send (8-bit)
    input  [7:0]  i_clk_div,  // Clock divider for SPI speed
    output reg [7:0]  o_data,     // Received data
    output reg    o_done,     // Transaction done flag
    output reg    o_sclk,     // SPI clock
    output reg    o_mosi,     // Master Out, Slave In
    output reg    o_ss_n,     // Slave Select (active low)
    input         i_miso      // Master In, Slave Out
);

    // SPI States

    localparam IDLE = 2'b00,
                TRANSFER = 2'b01,
                DONE = 2'b10;

    reg [1:0] state;

    reg [7:0] shift_reg;  // Shift register for data
    reg [2:0] bit_cnt;    // Bit counter (0-7)
    reg [7:0] clk_cnt;    // Clock divider counter
    reg sclk_toggle;      // SCLK toggle flag

    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            state      <= IDLE;
            o_sclk     <= 0;
            o_ss_n     <= 1; // Deactivate slave
            bit_cnt    <= 0;
            shift_reg  <= 0;
            clk_cnt    <= 0;
            sclk_toggle <= 0;
            o_done     <= 0;
        end else begin
            case (state)
                IDLE: begin
                    o_done <= 0;
                    if (i_start) begin
                        state     <= TRANSFER;
                        o_ss_n    <= 0;        // Activate slave
                        shift_reg <= i_data;   // Load data into shift register
                        bit_cnt   <= 0;
                        clk_cnt   <= 0;
                    end
                end

                TRANSFER: begin
                    if (clk_cnt == i_clk_div) begin
                        clk_cnt <= 0;
                        sclk_toggle <= ~sclk_toggle;

                        if (sclk_toggle) begin
                            o_sclk <= 1;
                        end else begin
                            o_sclk <= 0;
                            o_mosi <= shift_reg[7];   // Send MSB first
                            shift_reg <= {shift_reg[6:0], i_miso}; // Shift MISO in

                            if (bit_cnt == 7) begin
                                state <= DONE;
                            end else begin
                                bit_cnt <= bit_cnt + 1;
                            end
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                DONE: begin
                    o_done  <= 1;
                    o_ss_n  <= 1; // Deactivate slave
                    o_data  <= shift_reg; // Capture received data
                    state   <= IDLE;
                end
            endcase
        end
    end

endmodule
