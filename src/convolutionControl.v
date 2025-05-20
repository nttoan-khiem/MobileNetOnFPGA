module convolutionControl(
    input               i_clk,
    input               i_reset,
    input               i_start,
    input               i_opcode,
    input               i_validRam,
    output [107:0]      o_addrRead0,
    output [107:0]      o_addrRead1,
    output [107:0]      o_addrRead2,
    output reg          o_startRam,
    output reg          o_selRamD0,
    output reg [11:0]   o_addrWrite0,
    output reg [11:0]   o_addrWrite1,
    output reg [11:0]   o_addrWrite2,
    output reg          o_wrEnable,
    output reg          o_finish,
    output [11:0]       o_localAddr 
);
localparam [2:0]    idle = 3'd0,
                    readRam = 3'd1,
                    waitDone = 3'd2,
                    setWrite = 3'd3,
                    update = 3'd4,
                    finish = 3'd5;

reg [2:0] state_q, state_d;
reg [11:0] addrLocal_q, addrLocal_d;
//output of state
//address read port for ram source
reg [11:0] addrRead0;
reg [11:0] addrRead1;
reg [11:0] addrRead2;
reg [11:0] addrRead3;
reg [11:0] addrRead4;
reg [11:0] addrRead5;
reg [11:0] addrRead6;
reg [11:0] addrRead7;
reg [11:0] addrRead8;
//-----
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
                state_d = readRam;
            end else begin 
                state_d = idle;
            end
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = 12'd0;
            o_addrWrite1 = 12'd0;
            o_addrWrite2 = 12'd0;
            o_wrEnable = 0;
            o_finish = 0;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            addrLocal_d = 12'd0;
        end
        readRam: begin 
            state_d = waitDone;
            o_startRam = 1;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = addrLocal_q;
            o_addrWrite1 = addrLocal_q;
            o_addrWrite2 = addrLocal_q;
            o_wrEnable = 0;
            o_finish = 0;
            addrRead0 = addrLocal_q - 12'd65;
            addrRead1 = addrLocal_q - 12'd64;
            addrRead2 = addrLocal_q - 12'd63;
            addrRead3 = addrLocal_q - 12'd1;
            addrRead4 = addrLocal_q;  //center address
            addrRead5 = addrLocal_q + 12'd1;
            addrRead6 = addrLocal_q + 12'd63;
            addrRead7 = addrLocal_q + 12'd64;
            addrRead8 = addrLocal_q + 12'd65;
            addrLocal_d = addrLocal_q;
        end
        waitDone: begin 
            if(i_validRam) begin 
                state_d = setWrite;
            end else begin 
                state_d = waitDone;
            end
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = addrLocal_q;
            o_addrWrite1 = addrLocal_q;
            o_addrWrite2 = addrLocal_q;
            o_wrEnable = 0;
            o_finish = 0;
            addrRead0 = addrLocal_q - 12'd65;
            addrRead1 = addrLocal_q - 12'd64;
            addrRead2 = addrLocal_q - 12'd63;
            addrRead3 = addrLocal_q - 12'd1;
            addrRead4 = addrLocal_q;  //center address
            addrRead5 = addrLocal_q + 12'd1;
            addrRead6 = addrLocal_q + 12'd63;
            addrRead7 = addrLocal_q + 12'd64;
            addrRead8 = addrLocal_q + 12'd65;
            addrLocal_d = addrLocal_q;
        end
        setWrite: begin 
            state_d = update;
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = addrLocal_q;
            o_addrWrite1 = addrLocal_q;
            o_addrWrite2 = addrLocal_q;
            o_wrEnable = 1;
            o_finish = 0;
            addrRead0 = addrLocal_q - 12'd65;
            addrRead1 = addrLocal_q - 12'd64;
            addrRead2 = addrLocal_q - 12'd63;
            addrRead3 = addrLocal_q - 12'd1;
            addrRead4 = addrLocal_q;  //center address
            addrRead5 = addrLocal_q + 12'd1;
            addrRead6 = addrLocal_q + 12'd63;
            addrRead7 = addrLocal_q + 12'd64;
            addrRead8 = addrLocal_q + 12'd65;
            addrLocal_d = addrLocal_q;
        end
        update: begin 
            if(addrLocal_q == 12'd4095) begin 
                state_d = finish;
            end else begin 
                state_d = readRam;
            end
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = addrLocal_q;
            o_addrWrite1 = addrLocal_q;
            o_addrWrite2 = addrLocal_q;
            o_wrEnable = 0;
            o_finish = 0;
            addrRead0 = addrLocal_q - 12'd65;
            addrRead1 = addrLocal_q - 12'd64;
            addrRead2 = addrLocal_q - 12'd63;
            addrRead3 = addrLocal_q - 12'd1;
            addrRead4 = addrLocal_q;  //center address
            addrRead5 = addrLocal_q + 12'd1;
            addrRead6 = addrLocal_q + 12'd63;
            addrRead7 = addrLocal_q + 12'd64;
            addrRead8 = addrLocal_q + 12'd65;
            addrLocal_d = addrLocal_q + 12'd1;
        end
        finish: begin 
            state_d = idle;
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = 12'd0;
            o_addrWrite1 = 12'd0;
            o_addrWrite2 = 12'd0;
            o_wrEnable = 0;
            o_finish = 1;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            addrLocal_d = 12'd0;
        end
        default: begin 
            state_d = idle;
            o_startRam = 0;
            o_selRamD0 = i_opcode;
            o_addrWrite0 = 12'd0;
            o_addrWrite1 = 12'd0;
            o_addrWrite2 = 12'd0;
            o_wrEnable = 0;
            o_finish = 0;
            addrRead0 = 12'd0;
            addrRead1 = 12'd0;
            addrRead2 = 12'd0;
            addrRead3 = 12'd0;
            addrRead4 = 12'd0;
            addrRead5 = 12'd0;
            addrRead6 = 12'd0;
            addrRead7 = 12'd0;
            addrRead8 = 12'd0;
            addrLocal_d = 12'd0;
        end
    endcase
end
assign o_addrRead0 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};
assign o_addrRead1 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};
assign o_addrRead2 = {addrRead8, addrRead7, addrRead6, addrRead5, addrRead4, addrRead3, addrRead2, addrRead1, addrRead0};
assign o_localAddr = addrLocal_q;
endmodule