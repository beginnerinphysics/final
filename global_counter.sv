module global_counter#(parameter DWIDTH = 8)(
    input rst, //shreg[8]會讓rst歸零 aka HSYNC
    input clk,
    output reg[DWIDTH-1:0] counter
);
reg stop=0;
always@(posedge rst or posedge clk)begin//在always block裡面不會有latch,條件不用補滿
    if(rst) begin
        counter <= 'b0;
		stop <= 'b0;
    end
    else if(!stop)begin//類似mutex
        counter <= counter+1;
	end
end
always@(negedge counter[DWIDTH-1])begin
    if(!rst)begin
        stop<=1;
    end
end
endmodule
