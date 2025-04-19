module storeCamControl(
    input               i_clk,
    input               i_reset,
    input               i_start,
    input [9:0]         i_remainOnFifo,
    input               i_process,
    input               i_sdramReady,
    input               i_complete, //complete signal of controlWriteFifo
    input [15:0]        i_dataFifo,
    output reg          o_get,
    output reg          o_EnReadFifo,
    output reg          o_RdClkFifo,
    output     [15:0]   o_dataSdram,
    output reg [18:0]   o_addressToSdram,
    output reg          o_wrSdram,
    output reg          o_finish
);

localparam [3:0]    idle = 4'd0,
                    start = 4'd1,
                    suspend = 4'd2,
                    readFifo0 = 4'd3,
                    readFifo1 = 4'd4,
                    setRed = 4'd5,
                    wait0 = 4'd6,
                    setGreen = 4'd7,
                    wait1 = 4'd8,
                    setBlue = 4'd9,
                    wait2 = 4'd10,
                    update = 4'd11,
                    finish = 4'd12;

reg [3:0] state_q, state_d;
reg [18:0] addrLocal_q, addrLocal_d;
reg [7:0] dataToSdram8;

always @(posedge i_clk or negedge i_reset) begin    //sequential circuit update state, addr local 
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
            if(i_start & i_reset) begin 
                state_d = start;
            end else begin 
                state_d = idle;
            end
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = 19'd0;
        end
        start: begin 
            if(i_process) begin 
                state_d = suspend;
            end else begin 
                state_d = start; 
            end
            o_get = 1;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = 19'd0;
        end
        suspend: begin 
            if((i_remainOnFifo > 10'd16) | (i_complete)) begin 
                state_d = readFifo0;
            end else begin  
                state_d = suspend;
            end
            o_get = 0;
            o_EnReadFifo = 1;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        readFifo0: begin 
            state_d = readFifo1;
            o_get = 0;
            o_EnReadFifo = 1;
            o_RdClkFifo = 1;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        readFifo1: begin 
            state_d = setRed;
            o_get = 0;
            o_EnReadFifo = 1;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        setRed: begin 
            state_d = wait0;
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0,i_dataFifo[15:11], 1'd0};
            o_addressToSdram = addrLocal_q;
            o_wrSdram = 1;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        wait0: begin 
            if(i_sdramReady) begin 
                state_d = setGreen;
            end else begin 
                state_d = wait0;
            end
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0,i_dataFifo[15:11], 1'd0};
            o_addressToSdram = addrLocal_q;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        setGreen: begin 
            state_d = wait1;
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0,i_dataFifo[10:5]};
            o_addressToSdram = addrLocal_q + 19'd4096;    //sdram region 2 store feature Green
            o_wrSdram = 1;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        wait1: begin 
            if(i_sdramReady) begin 
                state_d = setBlue;
            end else begin 
                state_d = wait1;
            end
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0,i_dataFifo[10:5]};
            o_addressToSdram = addrLocal_q + 19'd4096;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        setBlue: begin 
            state_d = wait2;
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0, i_dataFifo[4:0], 1'd0};
            o_addressToSdram = addrLocal_q + 19'd8192;    //sdram region 2 store feature Green
            o_wrSdram = 1;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        wait2: begin 
            if(i_sdramReady) begin 
                state_d = update;
            end else begin 
                state_d = wait2;
            end
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = {2'd0, i_dataFifo[4:0], 1'd0};
            o_addressToSdram = addrLocal_q + 19'd8192;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q;
        end
        update: begin 
            if((~i_complete) | (i_remainOnFifo > 10'd0)) begin 
                state_d = suspend;
            end else begin 
                state_d = finish;
            end
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = addrLocal_q + 19'd1; //update local address 
        end
        finish: begin 
            state_d = idle;
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 1;
            addrLocal_d = 19'd0; 
        end
        default: begin 
            state_d = idle;
            o_get = 0;
            o_EnReadFifo = 0;
            o_RdClkFifo = 0;
            dataToSdram8 = 8'd0;
            o_addressToSdram = 19'd0;
            o_wrSdram = 0;
            o_finish = 0;
            addrLocal_d = 19'd0; 
        end
    endcase
end

assign o_dataSdram = {8'd0, dataToSdram8}; //assign to 16 bit for SDRAM (Extend unsigned)

endmodule