module writeBackControl (
    input i_clk,
    input i_reset,
    input i_sdramReady,
    input [18:0] i_baseAddr0,
    input [18:0] i_baseAddr1,
    input [18:0] i_baseAddr2,
    input i_start,
    output [18:0] o_addrToRam0,
    output [18:0] o_addrToRam1,
    output [18:0] o_addrToRam2,
    output reg  o_quickRam,
    output reg [18:0] o_addrToSdram,
    output reg o_wrSdram,
    output reg [1:0] o_selData,
    output reg o_finish
);
localparam [3:0]    idle = 4'd0,
                    setRam = 4'd1,
                    setSdram0 = 4'd2,
                    waitDone0 = 4'd3,
                    setSdram1 = 4'd4,
                    waitDone1 = 4'd5,
                    setSdram2 = 4'd6,
                    waitDone2 = 4'd7,
                    update = 4'd8,
                    finish = 4'd9;

reg [18:0] addrLocal_q, addrLocal_d;
reg [3:0] state_q, state_d; 

always @(posedge i_clk or negedge i_reset) begin  //update next state, local address and handle reset.
    if(!i_reset) begin 
        state_q <= idle;
        addrLocal_q <= 19'd0;
    end else begin 
        state_q <= state_d;
        addrLocal_q <= addrLocal_d;
    end
end

always @(*) begin  //combitional ciucirt control state machine.
    case (state_q)
        idle: begin 
            if(i_reset & i_start) begin 
                state_d = setRam;
            end else begin 
                state_d = idle;
            end
            o_finish = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = 19'd0;
            o_wrSdram = 0;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
        setRam: begin 
            state_d = setSdram0;
            o_finish = 0;
            o_addrToSdram = 0;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 0;
            o_quickRam = 1;
            o_selData = 2'd0;
        end
        setSdram0: begin 
            state_d = waitDone0;
            o_finish = 0;
            o_addrToSdram = i_baseAddr0 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 1;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
        waitDone0: begin 
            if(i_sdramReady) begin 
                state_d = setSdram1;
            end else begin 
                state_d = waitDone0;
            end
            o_finish = 0;
            o_addrToSdram = i_baseAddr0 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 0;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
        setSdram1: begin 
            state_d = waitDone1;
            o_finish = 0;
            o_addrToSdram = i_baseAddr1 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 1;
            o_quickRam = 0;
            o_selData = 2'd1;
        end
        waitDone1: begin 
            if(i_sdramReady) begin 
                state_d = setSdram2;
            end else begin 
                state_d = waitDone1;
            end
            o_finish = 0;
            o_addrToSdram = i_baseAddr1 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 0;
            o_quickRam = 0;
            o_selData = 2'd1;
        end
        setSdram2: begin 
            state_d = waitDone2; 
            o_finish = 0; 
            o_addrToSdram = i_baseAddr2 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 1;
            o_quickRam = 0;
            o_selData = 2'd2;
        end
        waitDone2: begin 
            if(i_sdramReady) begin 
                state_d = update;
            end else begin 
                state_d = waitDone2;
            end
            o_finish = 0;
            o_addrToSdram = i_baseAddr2 + addrLocal_q;
            addrLocal_d = addrLocal_q;
            o_wrSdram = 0;
            o_quickRam = 0;
            o_selData = 2'd2;
        end
        update: begin 
            if(addrLocal_q == 19'd4095) begin 
                state_d = finish;
            end else begin 
                state_d = setRam;
            end
            o_finish = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = addrLocal_q + 19'd1;
            o_wrSdram = 0;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
        finish: begin 
            state_d = idle;
            o_finish = 1;
            o_addrToSdram = 19'd0;
            addrLocal_d = 19'd0;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
        default: begin 
            state_d = idle;
            o_finish = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = 19'd0;
            o_quickRam = 0;
            o_selData = 2'd0;
        end
    endcase
end

assign o_addrToRam0 = addrLocal_q[11:0];
assign o_addrToRam1 = addrLocal_q[11:0];
assign o_addrToRam2 = addrLocal_q[11:0];

endmodule