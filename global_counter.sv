module global_counter#(parameter DWIDTH = 8)(
    input rst, //shreg[8]會讓rst歸零 aka HSYNC
    input clk,
    output reg[DWIDTH:0] counter
);
reg counterof=0;
always@(posedge rst or posedge clk)begin
    if(rst) begin
        counter <= 'b0;
		  counterof <= 'b0;
    end
    else if(!counterof)begin
        {counterof,counter} <= {counter+1};
	 end
    else begin
	     counter <= counter;
	 end
end
endmodule
