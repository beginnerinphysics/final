module global_counter#(parameter DWIDTH = 8)(
    input start, //接在posedge,讓counter開始數
    input clk,
    output reg[DWIDTH-1:0] counter
);
//reg [1:0] stop=2'b00;//stop[1]表示initial,stop[0]表示數完
reg launch=1'b0;
always@(posedge start or posedge clk)begin//在always block裡面不會有latch,條件不用補滿
    if(start && launch == 0) begin
        counter <= 'b1;
		launch <= 1;
    end

	else if(launch)begin
	    counter <= counter +1;
	end
end
always@(negedge counter[DWIDTH-1])begin

    //  launch[0] <= 1;
        launch <= 0;
end
endmodule
