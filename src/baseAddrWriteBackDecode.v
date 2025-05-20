module baseAddrWriteBackDecode(
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
            featureIndex0 = 7'd3;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd1: begin 
            featureIndex0 = 7'd4;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd2: begin 
            featureIndex0 = 7'd5;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd3: begin 
            featureIndex0 = 7'd6;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd4: begin 
            featureIndex0 = 7'd7;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd5: begin 
            featureIndex0 = 7'd8;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd6: begin 
            featureIndex0 = 7'd9;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end
        6'd7: begin 
            featureIndex0 = 7'd10;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end
        6'd8: begin 
            featureIndex0 = 7'd11;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd9: begin 
            featureIndex0 = 7'd12;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd10: begin 
            featureIndex0 = 7'd13;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end  
        6'd11: begin 
            featureIndex0 = 7'd14;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end  
        6'd12: begin 
            featureIndex0 = 7'd15;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd13: begin 
            featureIndex0 = 7'd16;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd14: begin 
            featureIndex0 = 7'd17;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd15: begin 
            featureIndex0 = 7'd18;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end 
        6'd16: begin 
            featureIndex0 = 7'd19;
            featureIndex1 = 7'd20;
            featureIndex2 = 7'd21;
        end 
        6'd17: begin 
            featureIndex0 = 7'd22;
            featureIndex1 = 7'd23;
            featureIndex2 = 7'd24;
        end 
        6'd18: begin 
            featureIndex0 = 7'd25;
            featureIndex1 = 7'd26;
            featureIndex2 = 7'd27;
        end 
        6'd19: begin 
            featureIndex0 = 7'd28;
            featureIndex1 = 7'd29;
            featureIndex2 = 7'd30;
        end 
        6'd20: begin 
            featureIndex0 = 7'd31;
            featureIndex1 = 7'd32;
            featureIndex2 = 7'd33;
        end 
        6'd21: begin 
            featureIndex0 = 7'd34;
            featureIndex1 = 7'd35;
            featureIndex2 = 7'd36;
        end 
        6'd22: begin 
            featureIndex0 = 7'd37;
            featureIndex1 = 7'd38;
            featureIndex2 = 7'd39;
        end 
        6'd23: begin 
            featureIndex0 = 7'd40;
            featureIndex1 = 7'd41;
            featureIndex2 = 7'd42;
        end 
        6'd24: begin 
            featureIndex0 = 7'd43;
            featureIndex1 = 7'd44;
            featureIndex2 = 7'd45;
        end 
        6'd25: begin 
            featureIndex0 = 7'd46;
            featureIndex1 = 7'd47;
            featureIndex2 = 7'd48;
        end 
        6'd26: begin 
            featureIndex0 = 7'd49;
            featureIndex1 = 7'd50;
            featureIndex2 = 7'd51;
        end
        6'd27: begin 
            featureIndex0 = 7'd52;
            featureIndex1 = 7'd53;
            featureIndex2 = 7'd54;
        end 
        6'd28: begin 
            featureIndex0 = 7'd55;
            featureIndex1 = 7'd56;
            featureIndex2 = 7'd57;
        end 
        6'd29: begin 
            featureIndex0 = 7'd58;
            featureIndex1 = 7'd59;
            featureIndex2 = 7'd60;
        end 
        6'd30: begin 
            featureIndex0 = 7'd61;
            featureIndex1 = 7'd62;
            featureIndex2 = 7'd63;
        end 
        6'd31: begin 
            featureIndex0 = 7'd64;
            featureIndex1 = 7'd65;
            featureIndex2 = 7'd66;
        end 
        default: begin 
            featureIndex0 = 7'd67;
            featureIndex1 = 7'd67;
            featureIndex2 = 7'd67;
        end
    endcase
end
assign o_baseAddr0 = featureIndex0 *19'd64*19'd64;
assign o_baseAddr1 = featureIndex1 *19'd64*19'd64;
assign o_baseAddr2 = featureIndex2 *19'd64*19'd64;
endmodule