module baseAddrFetDecode(
    input [5:0] i_opcode,
    output [18:0] o_baseAddr0,
    output [18:0] o_baseAddr1,
    output [18:0] o_baseAddr2
);
reg [6:0] featureIndex0;
reg [6:0] featureIndex1;
reg [6:0] featureIndex2;
always @(*) begin
    case (i_opcode)
        6'd0: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd1: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd2: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd3: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd4: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd5: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd6: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end
        6'd7: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end
        6'd8: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd9: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd10: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end  
        6'd11: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end  
        6'd12: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd13: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd14: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd15: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd1;
            featureIndex2 = 7'd2;
        end 
        6'd16: begin 
            featureIndex0 = 7'd3;
            featureIndex1 = 7'd4;
            featureIndex2 = 7'd5;
        end 
        6'd17: begin 
            featureIndex0 = 7'd6;
            featureIndex1 = 7'd7;
            featureIndex2 = 7'd8;
        end 
        6'd18: begin 
            featureIndex0 = 7'd9;
            featureIndex1 = 7'd10;
            featureIndex2 = 7'd11;
        end 
        6'd19: begin 
            featureIndex0 = 7'd12;
            featureIndex1 = 7'd13;
            featureIndex2 = 7'd14;
        end 
        6'd20: begin 
            featureIndex0 = 7'd15;
            featureIndex1 = 7'd16;
            featureIndex2 = 7'd17;
        end 
        6'd21: begin 
            featureIndex0 = 7'd18;
            featureIndex1 = 7'd19;
            featureIndex2 = 7'd20;
        end 
        6'd22: begin 
            featureIndex0 = 7'd21;
            featureIndex1 = 7'd22;
            featureIndex2 = 7'd23;
        end 
        6'd23: begin 
            featureIndex0 = 7'd24;
            featureIndex1 = 7'd25;
            featureIndex2 = 7'd26;
        end 
        6'd24: begin 
            featureIndex0 = 7'd27;
            featureIndex1 = 7'd28;
            featureIndex2 = 7'd29;
        end 
        6'd25: begin 
            featureIndex0 = 7'd30;
            featureIndex1 = 7'd31;
            featureIndex2 = 7'd32;
        end 
        6'd26: begin 
            featureIndex0 = 7'd33;
            featureIndex1 = 7'd34;
            featureIndex2 = 7'd35;
        end
        6'd27: begin 
            featureIndex0 = 7'd36;
            featureIndex1 = 7'd37;
            featureIndex2 = 7'd38;
        end 
        6'd28: begin 
            featureIndex0 = 7'd39;
            featureIndex1 = 7'd40;
            featureIndex2 = 7'd41;
        end 
        6'd29: begin 
            featureIndex0 = 7'd42;
            featureIndex1 = 7'd43;
            featureIndex2 = 7'd44;
        end 
        6'd30: begin 
            featureIndex0 = 7'd45;
            featureIndex1 = 7'd46;
            featureIndex2 = 7'd47;
        end 
        6'd31: begin 
            featureIndex0 = 7'd48;
            featureIndex1 = 7'd49;
            featureIndex2 = 7'd50;
        end 
        6'd32: begin 
            featureIndex0 = 7'd51;
            featureIndex1 = 7'd52;
            featureIndex2 = 7'd53;
        end 
        6'd33: begin 
            featureIndex0 = 7'd54;
            featureIndex1 = 7'd55;
            featureIndex2 = 7'd56;
        end 
        6'd34: begin 
            featureIndex0 = 7'd57;
            featureIndex1 = 7'd58;
            featureIndex2 = 7'd59;
        end 
        6'd35: begin 
            featureIndex0 = 7'd60;
            featureIndex1 = 7'd61;
            featureIndex2 = 7'd62;
        end 
        6'd36: begin 
            featureIndex0 = 7'd63;
            featureIndex1 = 7'd64;
            featureIndex2 = 7'd65;
        end 
        6'd37: begin 
            featureIndex0 = 7'd66;
            featureIndex1 = 7'd0;
            featureIndex2 = 7'd0;
        end 
        default: begin 
            featureIndex0 = 7'd0;
            featureIndex1 = 7'd0;
            featureIndex2 = 7'd0;
        end
    endcase
end
assign o_baseAddr0 = featureIndex0 *64*64;
assign o_baseAddr1 = featureIndex1 *64*64;
assign o_baseAddr2 = featureIndex2 *64*64;

endmodule