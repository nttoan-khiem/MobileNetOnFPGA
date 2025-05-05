module cameraStartConfig(
    input i_clk,
    input i_reset,
    output reg o_startConf
);
reg [17:0] counter;
always @(posedge i_clk or negedge i_reset) begin
    if(!i_reset) begin 
        counter <= 18'd0;
    end else begin 
        if(counter < 18'd260000) begin 
            counter <= counter + 18'd1;
        end else begin 
            counter <= counter;
        end
    end
end
always @(*) begin
    if((counter > 18'd250000) & (counter < 18'd255000)) begin 
        o_startConf = 0;
    end else begin 
        o_startConf = 1;
    end
end 
endmodule