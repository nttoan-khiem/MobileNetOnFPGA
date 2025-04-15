// sdram_controller.v
// Complete SDRAM Controller for DE0-nano (simplified)
// Inputs: addr (24-bit), data_in (16-bit), rw (1: read, 0: write), start (command trigger)
// Outputs: data_out (16-bit), busy, complete
// SDRAM interface signals provided for a typical 16-bit SDRAM device.
// Note: This is a simplified example. Adjust timing parameters and state machine details
//       to meet your SDRAM device’s requirements.

module sdram_controller (
    input           clk,
    input           rst,
    // Command interface
    input  [23:0]   addr,      // 24-bit address: [23:11] = row, [10:9] = bank, [8:0] = column
    input  [15:0]   data_in,   // Data to write
    input           rw,        // 1: read, 0: write
    input           start,     // Command strobe (active high when new request is available)
    output reg [15:0] data_out, // Data read from SDRAM
    output reg      busy,      // High while operation in progress
    output reg      complete,  // One-cycle pulse when operation completes

    // SDRAM interface signals
    output reg [12:0] sdram_addr,
    output reg [1:0]  sdram_ba,
    output reg        sdram_cas_n,
    output reg        sdram_ras_n,
    output reg        sdram_we_n,
    output reg        sdram_cke,
    output reg        sdram_cs_n,
    inout      [15:0] sdram_dq
);

  //-------------------------------------------------------------------------
  // Parameters and State Definitions
  //-------------------------------------------------------------------------
  // Initialization timing parameters (in clock cycles) – adjust per your SDRAM datasheet
  localparam DELAY_POWERUP   = 1000;
  localparam DELAY_PRECHARGE = 50;
  localparam DELAY_REFRESH   = 50;
  localparam DELAY_LOAD_MODE = 50;

  // Operational timing parameters
  localparam tRCD = 3;  // Activate-to-read/write delay
  localparam tCL  = 3;  // CAS latency (for read)

  // State encoding
  localparam STATE_INIT         = 4'd0;
  localparam STATE_INIT_PRECH   = 4'd1;
  localparam STATE_INIT_REF1    = 4'd2;
  localparam STATE_INIT_REF2    = 4'd3;
  localparam STATE_INIT_LMR     = 4'd4;
  localparam STATE_IDLE         = 4'd5;
  localparam STATE_ACTIVATE     = 4'd6;
  localparam STATE_TRCD         = 4'd7;
  localparam STATE_READ_CMD     = 4'd8;
  localparam STATE_READ_WAIT    = 4'd9;
  localparam STATE_READ_DONE    = 4'd10;
  localparam STATE_WRITE_CMD    = 4'd11;
  localparam STATE_WRITE_WAIT   = 4'd12;
  localparam STATE_WRITE_DONE   = 4'd13;

  reg [3:0] state;
  reg [15:0] delay_cnt;

  // Latching the command parameters once a new command is detected
  reg [23:0] cmd_addr;
  reg [15:0] cmd_data;
  reg        cmd_rw;  // 1 = read, 0 = write

  // Internal flag to drive the bidirectional data bus during write operations.
  reg drive_data;
  // Tri-state control for sdram_dq: drive data during write states; otherwise, high impedance.
  assign sdram_dq = (drive_data) ? data_in : 16'bz;

  // Extract row, bank, and column from command address.
  // For this example, assume:
  //   row  : bits [23:11] (13 bits)
  //   bank : bits [10:9]  (2 bits)
  //   col  : bits [8:0]   (9 bits)
  wire [12:0] row_addr  = cmd_addr[23:11];
  wire [1:0]  bank_addr = cmd_addr[10:9];
  wire [8:0]  col_addr  = cmd_addr[8:0];

  //-------------------------------------------------------------------------
  // Main State Machine
  //-------------------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset state: initialize SDRAM control signals and internal registers.
      state        <= STATE_INIT;
      delay_cnt    <= 16'd0;
      busy         <= 1'b1;
      complete     <= 1'b0;
      drive_data   <= 1'b0;
      // SDRAM control defaults (inactive commands)
      sdram_cke    <= 1'b0;
      sdram_cs_n   <= 1'b1;
      sdram_ras_n  <= 1'b1;
      sdram_cas_n  <= 1'b1;
      sdram_we_n   <= 1'b1;
      sdram_addr   <= 13'd0;
      sdram_ba     <= 2'd0;
      data_out     <= 16'd0;
    end else begin
      case (state)
        //======================================================================
        // Initialization Sequence
        //======================================================================
        STATE_INIT: begin
          // Enable clock and wait for power-up stabilization.
          sdram_cke   <= 1'b1;
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b1;
          sdram_cas_n <= 1'b1;
          sdram_we_n  <= 1'b1;
          if (delay_cnt < DELAY_POWERUP)
            delay_cnt <= delay_cnt + 1;
          else begin
            delay_cnt <= 16'd0;
            state <= STATE_INIT_PRECH;
          end
        end

        // Precharge all banks
        STATE_INIT_PRECH: begin
          // Issue PRECHARGE ALL command: CS=0, RAS=0, CAS=1, WE=0.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b0;
          sdram_cas_n <= 1'b1;
          sdram_we_n  <= 1'b0;
          // Set A10 high to precharge all banks.
          sdram_addr[10] <= 1'b1;
          if (delay_cnt < DELAY_PRECHARGE)
            delay_cnt <= delay_cnt + 1;
          else begin
            delay_cnt <= 16'd0;
            state <= STATE_INIT_REF1;
          end
        end

        // First auto-refresh command
        STATE_INIT_REF1: begin
          // Issue AUTO-REFRESH: CS=0, RAS=0, CAS=0, WE=1.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b0;
          sdram_cas_n <= 1'b0;
          sdram_we_n  <= 1'b1;
          if (delay_cnt < DELAY_REFRESH)
            delay_cnt <= delay_cnt + 1;
          else begin
            delay_cnt <= 16'd0;
            state <= STATE_INIT_REF2;
          end
        end

        // Second auto-refresh command
        STATE_INIT_REF2: begin
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b0;
          sdram_cas_n <= 1'b0;
          sdram_we_n  <= 1'b1;
          if (delay_cnt < DELAY_REFRESH)
            delay_cnt <= delay_cnt + 1;
          else begin
            delay_cnt <= 16'd0;
            state <= STATE_INIT_LMR;
          end
        end

        // Load Mode Register
        STATE_INIT_LMR: begin
          // Issue LOAD MODE REGISTER: CS=0, RAS=0, CAS=0, WE=0.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b0;
          sdram_cas_n <= 1'b0;
          sdram_we_n  <= 1'b0;
          // For example, load a mode register value.
          // (This value must be set per your SDRAM datasheet.)
          sdram_addr  <= 13'b0000_0100_0011;
          if (delay_cnt < DELAY_LOAD_MODE)
            delay_cnt <= delay_cnt + 1;
          else begin
            delay_cnt <= 16'd0;
            state <= STATE_IDLE;
            busy  <= 1'b0;  // Now ready for commands.
          end
        end

        //======================================================================
        // Idle: Wait for a new command request
        //======================================================================
        STATE_IDLE: begin
          // Drive no command (NOP)
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b1;
          sdram_cas_n <= 1'b1;
          sdram_we_n  <= 1'b1;
          drive_data  <= 1'b0;
          complete    <= 1'b0;
          busy        <= 1'b0;
          // Latch command when external 'start' is asserted.
          if (start) begin
            cmd_addr <= addr;
            cmd_data <= data_in;
            cmd_rw   <= rw;
            busy     <= 1'b1;
            state    <= STATE_ACTIVATE;
            delay_cnt<= 16'd0;
          end
        end

        //======================================================================
        // ACTIVATE: Open the row corresponding to the command address.
        //======================================================================
        STATE_ACTIVATE: begin
          // Issue ACTIVE command: CS=0, RAS=0, CAS=1, WE=1.
          // Provide the row address.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b0;
          sdram_cas_n <= 1'b1;
          sdram_we_n  <= 1'b1;
          sdram_addr  <= row_addr;
          sdram_ba    <= bank_addr;
          if (delay_cnt < tRCD) begin
            delay_cnt <= delay_cnt + 1;
          end else begin
            delay_cnt <= 16'd0;
            // Move to the appropriate command state based on read or write.
            if (cmd_rw) begin
              state <= STATE_READ_CMD;
            end else begin
              state <= STATE_WRITE_CMD;
            end
          end
        end

        //======================================================================
        // READ Operation Sequence
        //======================================================================
        STATE_READ_CMD: begin
          // Issue READ command:
          // Command: CS=0, RAS=1, CAS=0, WE=1.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b1;
          sdram_cas_n <= 1'b0;
          sdram_we_n  <= 1'b1;
          // Provide the column address.
          // Note: Some SDRAM parts require auto-precharge bits; here we ignore that.
          sdram_addr[8:0] <= col_addr;
          if (delay_cnt < tCL) begin
            delay_cnt <= delay_cnt + 1;
          end else begin
            delay_cnt <= 16'd0;
            state <= STATE_READ_DONE;
          end
        end

        STATE_READ_DONE: begin
          // Latch the data from the SDRAM data bus.
          data_out <= sdram_dq;
          complete <= 1'b1;  // Indicate read complete (one-cycle pulse)
          state    <= STATE_IDLE;
        end

        //======================================================================
        // WRITE Operation Sequence
        //======================================================================
        STATE_WRITE_CMD: begin
          // Issue WRITE command:
          // Command: CS=0, RAS=1, CAS=1, WE=0.
          sdram_cs_n  <= 1'b0;
          sdram_ras_n <= 1'b1;
          sdram_cas_n <= 1'b1;
          sdram_we_n  <= 1'b0;
          sdram_addr[8:0] <= col_addr;
          // Drive the data bus.
          drive_data <= 1'b1;
          state      <= STATE_WRITE_WAIT;
          delay_cnt  <= 16'd0;
        end

        STATE_WRITE_WAIT: begin
          // Wait a cycle (or more if required) for the write to be registered.
          if (delay_cnt < 1) begin
            delay_cnt <= delay_cnt + 1;
          end else begin
            delay_cnt <= 16'd0;
            state <= STATE_WRITE_DONE;
          end
        end

        STATE_WRITE_DONE: begin
          drive_data <= 1'b0;  // Stop driving the bus.
          complete  <= 1'b1;   // Indicate write complete.
          state     <= STATE_IDLE;
        end

        default: state <= STATE_IDLE;
      endcase
    end
  end

endmodule
