module fetchingControl(
    input [18:0]    i_baseAddr0,
    input [18:0]    i_baseAddr1,
    input [18:0]    i_baseAddr2,
    input           i_clk,
    input           i_reset,
    input           i_sdramReady,
    input           i_start,
    output reg      o_rdSdram,
    output reg [18:0] o_addrToSdram,
    output reg      o_finish,
    output reg      o_wrRam0,
    output reg      o_wrRam1,
    output reg      o_wrRam2,
    output  [11:0]  o_addrToRam
);
localparam [3:0]    idle = 4'd0,
                    setSdram0 = 4'd1,
                    waitSdram0 = 4'd2,
                    setRam0 = 4'd3,
                    setSdram1 = 4'd4,
                    waitSdram1 = 4'd5,
                    setRam1 = 4'd6,
                    setSdram2 = 4'd7,
                    waitSdram2 = 4'd8,
                    setRam2 = 4'd9,
                    update = 4'd10,
                    finish = 4'd11;

reg [3:0] state_q, state_d;
reg [18:0] addrLocal_q, addrLocal_d;

always @(posedge i_clk or negedge i_reset) begin   //update state and addr counter
    if(!i_reset) begin 
        state_q <= idle;
        addrLocal_q <= 19'd0;
    end else begin 
        state_q <= state_d;
        addrLocal_q <= addrLocal_d;
    end
end

always @(*) begin
    case (state_q)
        idle: begin 
            if(i_start) begin 
                state_d = setSdram0;
            end else begin 
                state_d = idle;
            end
            o_rdSdram = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = 0;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setSdram0: begin 
            state_d = waitSdram0;
            o_rdSdram = 1;
            o_addrToSdram = addrLocal_q + i_baseAddr0;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        waitSdram0: begin 
            if(i_sdramReady) begin 
                state_d = setRam0;
            end else begin 
                state_d = waitSdram0;
            end
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr0;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setRam0: begin 
            state_d = setSdram1;
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr1;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 1;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setSdram1: begin 
            state_d = waitSdram1;
            o_rdSdram = 1;
            o_addrToSdram = addrLocal_q + i_baseAddr1;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        waitSdram1: begin 
            if(i_sdramReady) begin 
                state_d = setRam1;
            end else begin 
                state_d = waitSdram1;
            end
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr1;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setRam1: begin 
            state_d = setSdram2;
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr1;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 1;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setSdram2: begin 
            state_d = waitSdram2;
            o_rdSdram = 1;
            o_addrToSdram = addrLocal_q + i_baseAddr2;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        waitSdram2: begin 
            if(i_sdramReady) begin 
                state_d = setRam2;
            end else begin 
                state_d = waitSdram2;
            end
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr2;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        setRam2: begin 
            state_d = update;
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr2;
            addrLocal_d = addrLocal_q;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 1;
            o_finish = 0;
        end
        update: begin 
            if(addrLocal_q == 19'd4095) begin //final data address
                state_d = finish;
            end else begin 
                state_d = setSdram0;
            end
            o_rdSdram = 0;
            o_addrToSdram = addrLocal_q + i_baseAddr0;
            addrLocal_d = addrLocal_q + 19'd1;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
        finish: begin 
            state_d = idle;
            o_rdSdram = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = 0;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 1;
        end
        default: begin 
            state_d = idle;
            o_rdSdram = 0;
            o_addrToSdram = 19'd0;
            addrLocal_d = 0;
            o_wrRam0 = 0;
            o_wrRam1 = 0;
            o_wrRam2 = 0;
            o_finish = 0;
        end
    endcase
end
assign o_addrToRam = addrLocal_q[11:0]; //just need 12 bit lower
endmodule