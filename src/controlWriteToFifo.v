module controlWriteToFifo(
    input wire [9:0]    i_xIndex,
    input wire [9:0]    i_yIndex,
    input wire          i_clk,
    input wire          i_reset,
    input wire          i_get,
    output reg          o_eWriteFifo,
    output reg          o_complete,
    output reg          o_process
);

localparam [1:0]    idle = 2'd0,
                    process = 2'd1,
                    finish = 2'd2;
reg [1:0] state_q, state_d;
reg masterE;

always @(posedge i_clk or negedge i_reset) begin    //sequential logic circuit update state
    if(!i_reset) begin 
        state_q <= idle;
    end else begin 
        state_q <= state_d;
    end
end

always @(*) begin     //combitional logic circuit control next state and output of state machine
    case (state_q)
        idle: begin 
            if((i_xIndex == 10'd0) & (i_yIndex == 10'd0) & (i_get) & (i_reset)) begin 
                state_d = process;
            end else begin 
                state_d = idle;
            end
            masterE = 0;
            o_complete = 1;
            o_process = 0;
        end
        process: begin 
            if((i_xIndex == 10'd64) & (i_yIndex == 10'd63)) begin 
                state_d = finish;
            end else begin 
                state_d = process;
            end
            masterE = 1;
            o_complete = 0;
            o_process = 1;
        end 
        finish: begin 
            state_d = idle;
            masterE = 0;
            o_complete = 1;
            o_process = 0;
        end
        default: begin 
            state_d = idle;
            masterE = 0;
            o_complete = 0;
            o_process = 0;
        end
    endcase
end

always @(*) begin //combitional logic circuit control o_eWriteFifo signal.
    if((i_xIndex <= 10'd64) & (i_yIndex < 10'd64) & (masterE)) begin  //only allow write to fifo x < 64 and y < 64 and when sate machine 
        o_eWriteFifo = 1;
    end else begin 
        o_eWriteFifo = 0;
    end
end
endmodule