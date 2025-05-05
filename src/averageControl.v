module averageControl(
    input i_clk,
    input i_reset,
    input i_start,
    input i_validRam,
    output [107:0] o_addrRead0,
    output [107:0] o_addrRead1,
    output [107:0] o_addrRead2,
    output reg o_writeEnable,
    output reg o_resetAverage,
    output reg o_mask,
    output reg o_startRam,
    output reg o_finish
);
localparam [2:0]    idle = 3'd0,
                    reset = 3'd1,
                    buffer = 3'd2,
                    setAddr = 3'd3,
                    waitDone = 3'd4,
                    writeAdd = 3'd5,
                    update = 3'd6,
                    finish = 3'd7;

reg [2:0] state_q, state_d;
reg [11:0] addrLocal_q, addrLocal_d;
reg [11:0] addrRead0;
reg [11:0] addrRead1;
reg [11:0] addrRead2;
reg [11:0] addrRead3;
reg [11:0] addrRead4;
reg [11:0] addrRead5;
reg [11:0] addrRead6;
reg [11:0] addrRead7;
reg [11:0] addrRead8;

always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        state_q <= idle;
        addrLocal_q <= 12'd0;
    end else begin 
        state_q <= state_d;
        addrLocal_q <= addrLocal_d;
    end
end

always @(*) begin
    case (state_q)
        idle: begin 
            if(i_start & i_reset) begin 
                state_d = reset;
            end else begin 
                state_d = idle;
            end
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            o_writeEnable = 0;
            o_mask = 0;
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = 12'd0;
        end 
        reset: begin 
            state_d = buffer;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            o_writeEnable = 0;
            o_mask = 0;
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 0;
            addrLocal_d = 12'd0;
        end
        buffer: begin 
            state_d = setAddr;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            o_writeEnable = 0;
            o_mask = 0;
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = 12'd0;
        end
        setAddr: begin 
            state_d = waitDone;
            addrRead0 = addrLocal_q;
            addrRead1 = addrLocal_q + 12'd1;
            addrRead2 = addrLocal_q + 12'd2;
            addrRead3 = addrLocal_q + 12'd3;
            addrRead4 = addrLocal_q + 12'd4;
            addrRead5 = addrLocal_q + 12'd5;
            addrRead6 = addrLocal_q + 12'd6;
            addrRead7 = addrLocal_q + 12'd7;
            addrRead8 = addrLocal_q + 12'd8;
            o_writeEnable = 0;
            if(addrLocal_q == 12'd4095) begin 
                o_mask = 0;
            end else begin 
                o_mask = 1;
            end
            o_startRam = 1;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = addrLocal_q;
        end
        waitDone: begin 
            if(i_validRam) begin 
                state_d = writeAdd;
            end else begin 
                state_d = waitDone;
            end
            addrRead0 = addrLocal_q;
            addrRead1 = addrLocal_q + 12'd1;
            addrRead2 = addrLocal_q + 12'd2;
            addrRead3 = addrLocal_q + 12'd3;
            addrRead4 = addrLocal_q + 12'd4;
            addrRead5 = addrLocal_q + 12'd5;
            addrRead6 = addrLocal_q + 12'd6;
            addrRead7 = addrLocal_q + 12'd7;
            addrRead8 = addrLocal_q + 12'd8;
            o_writeEnable = 0;
            if(addrLocal_q == 12'd4095) begin 
                o_mask = 0;
            end else begin 
                o_mask = 1;
            end
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = addrLocal_q;
        end
        writeAdd: begin 
            state_d = update;
            addrRead0 = addrLocal_q;
            addrRead1 = addrLocal_q + 12'd1;
            addrRead2 = addrLocal_q + 12'd2;
            addrRead3 = addrLocal_q + 12'd3;
            addrRead4 = addrLocal_q + 12'd4;
            addrRead5 = addrLocal_q + 12'd5;
            addrRead6 = addrLocal_q + 12'd6;
            addrRead7 = addrLocal_q + 12'd7;
            addrRead8 = addrLocal_q + 12'd8;
            o_writeEnable = 1;
            if(addrLocal_q == 12'd4095) begin 
                o_mask = 0;
            end else begin 
                o_mask = 1;
            end
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = addrLocal_q;
        end
        update: begin 
            addrRead0 = addrLocal_q;
            addrRead1 = addrLocal_q + 12'd1;
            addrRead2 = addrLocal_q + 12'd2;
            addrRead3 = addrLocal_q + 12'd3;
            addrRead4 = addrLocal_q + 12'd4;
            addrRead5 = addrLocal_q + 12'd5;
            addrRead6 = addrLocal_q + 12'd6;
            addrRead7 = addrLocal_q + 12'd7;
            addrRead8 = addrLocal_q + 12'd8;
            o_writeEnable = 0;
            if(addrLocal_q == 12'd4095) begin 
                state_d = finish;
                o_mask = 0;
            end else begin 
                state_d = setAddr;
                o_mask = 1;
            end
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = addrLocal_q + 12'd9;
        end
        finish: begin 
            state_d = idle;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            o_writeEnable = 0;
            o_mask = 0;
            o_startRam = 0;
            o_finish = 1;
            o_resetAverage = 1;
            addrLocal_d = 12'd0;
        end
        default: begin 
            state_d = idle;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            o_writeEnable = 0;
            o_mask = 0;
            o_startRam = 0;
            o_finish = 0;
            o_resetAverage = 1;
            addrLocal_d = 12'd0;
        end
    endcase
end

assign o_addrRead0 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};
assign o_addrRead1 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};
assign o_addrRead2 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};

endmodule