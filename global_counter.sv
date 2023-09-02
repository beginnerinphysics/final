module global_counter#(parameter DWIDTH = 8)(
    input rst, //shreg[8]會讓rst歸零 aka HSYNC
    input clk,
    output reg[DWIDTH-1:0] counter
);
reg stop=1'b0;//stop[1]表示initial,stop[0]表示數完
always@(posedge rst or posedge clk)begin//在always block裡面不會有latch,條件不用補滿
    if(rst) begin
        counter <= 'b0;
		stop <= 0;
    end
 //   else if(!stop)begin//類似mutex
 //       stop[1] <= 1;
//	end
	else if(!stop)begin
	    counter <= counter +1;
	end
end
always@(negedge counter[DWIDTH-1])begin
    if(!rst)begin
        stop <= 1;
    end
end
endmodule
