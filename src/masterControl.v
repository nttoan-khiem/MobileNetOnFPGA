module masterControl(
    input i_clk,
    input i_reset,
    input i_finish_cam,
    input i_finish_fet,
    input i_finish_conv,
    input i_finish_writeBack,
    input i_finish_ave,
    output reg o_startCam,
    output reg o_startFet, 
    output reg o_startConvolution,
    output reg o_startAve,
    output reg o_startWriteBack,
    output reg o_wrActiveCam,
    output reg o_opConv,
    output [5:0] o_opcode
);
localparam [4:0]    idle = 5'd0,
                    startCam = 5'd1,
                    waitDoneCam = 5'd2,
                    fet1 = 5'd3,
                    waitDoneFet1 = 5'd4,
                    convolution0 = 5'd5,
                    waitDoneConv0 = 5'd6,
                    writeBack1 = 5'd7,
                    waitDoneWriteBack1 = 5'd8,
                    update1 = 5'd9,
                    fet2 = 5'd10,
                    waitDoneFet2 = 5'd11,
                    convolution1 = 5'd12,
                    waitDoneConv1 = 5'd13,
                    writeBack2 = 5'd14,
                    waitDoneWriteBack2 = 5'd15,
                    update2 = 5'd16,
                    fet3 = 5'd17,
                    waitDoneFet3 = 5'd18,
                    average = 5'd19,
                    waitDoneAve = 5'd20,
                    update3 = 5'd21;
reg [4:0] state_q, state_d;
reg [5:0] opcode_q, opcode_d;

always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        state_q <= idle;
        opcode_q <= 6'd0;
    end else begin
        state_q <= state_d;
        opcode_q <= opcode_d;
    end
end

always @(*) begin
    case (state_q)
        idle: begin 
            state_d = startCam;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = 6'd0;
        end 
        startCam: begin 
            state_d = waitDoneCam;
            o_startCam = 1;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        waitDoneCam: begin 
            if(i_finish_cam) begin 
                state_d = fet1;
            end else begin 
                state_d = waitDoneCam;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        fet1: begin 
            state_d = waitDoneFet1;
            o_startCam = 0;
            o_startFet = 1;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        waitDoneFet1: begin 
            if(i_finish_fet) begin 
                state_d = convolution0;
            end else begin 
                state_d = waitDoneFet1;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        convolution0: begin 
            state_d = waitDoneConv0;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 1;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        waitDoneConv0: begin 
            if(i_finish_conv) begin 
                state_d = writeBack1;
            end else begin 
                state_d = waitDoneConv0;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        writeBack1: begin 
            state_d = waitDoneWriteBack1;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 1;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        waitDoneWriteBack1: begin 
            if(i_finish_writeBack) begin 
                state_d = update1;
            end else begin 
                state_d = waitDoneWriteBack1;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        update1: begin 
            if(opcode_q == 6'd15) begin 
                state_d = fet2;
            end else begin 
                state_d = convolution0;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q + 6'd1;
        end
        fet2: begin 
            state_d = waitDoneFet2;
            o_startCam = 0;
            o_startFet = 1;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        waitDoneFet2: begin 
            if(i_finish_fet) begin 
                state_d = convolution1;
            end else begin 
                state_d = waitDoneFet2;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        convolution1: begin 
            state_d = waitDoneConv1;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 1;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        waitDoneConv1: begin 
            if(i_finish_conv) begin 
                state_d = writeBack2;
            end else begin
                state_d = waitDoneConv1;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        writeBack2: begin 
            state_d = waitDoneWriteBack2;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 1;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        waitDoneWriteBack2: begin 
            if(i_finish_writeBack) begin 
                state_d = update2;
            end else begin
                state_d = waitDoneWriteBack2;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q;
        end
        update2: begin 
            if(opcode_q == 6'd31) begin 
                state_d = fet3;
            end else begin 
                state_d = fet2;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 1;
            opcode_d = opcode_q + 6'd1;
        end
        fet3: begin 
            state_d = waitDoneFet3;
            o_startCam = 0;
            o_startFet = 1;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        waitDoneFet3: begin 
            if(i_finish_fet) begin 
                state_d = average; 
            end else begin 
                state_d = waitDoneFet3;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        average: begin 
            state_d = waitDoneAve;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 1;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end 
        waitDoneAve: begin 
            if(i_finish_ave) begin 
                state_d = update3;
            end else begin 
                state_d = waitDoneAve;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q;
        end
        update3: begin 
            if(opcode_q == 6'd37) begin 
                state_d = idle;
            end else begin 
                state_d = fet3;
            end
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = opcode_q + 6'd1;
        end
        default: begin 
            state_d = idle;
            o_startCam = 0;
            o_startFet = 0;
            o_startConvolution = 0;
            o_startAve = 0;
            o_startWriteBack = 0;
            o_wrActiveCam = 0;
            o_opConv = 0;
            opcode_d = 6'd0;
        end
    endcase
end
assign o_opcode = opcode_q;
endmodule