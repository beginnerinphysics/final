module PWMblock#(parameter DWIDTH = 8)(
 //   input clk,
    input rst,
 //   input start,
    input [DWIDTH-1:0] data,
    input [DWIDTH-1:0] count,
    input hsync,//singal from shreg[8]
    output reg out
);
reg [DWIDTH-1:0] data_in ;
wire stop, clr;
//shreg[8]進來的時候表示counter從0準備開始數(這是counter設定的);而shreg[8]時, 如果pwm讀到的dataq不是0, 就會先把out設成1, 等到clr==1到out才會變成0
assign stop = ~(|(data_in ^ count)) ;
assign clr = stop || rst ;
/*
always@(posedge clr or posedge hsync)begin
    if(clr)begin
        out <= 0 ;
    end
    else if(!data)begin
        out <= 0 ;
    end
    else begin
        out <= 1 ;
    end
end
*/
always@(posedge clr or posedge hsync)begin
    if(hsync && data && !out)begin
        out <= 1;
    end
    else begin
        out <= 0;
    end
end
always@(posedge hsync)begin
    if(hsync)begin//if 是讓每一筆資料送進來的時候data_in的初始都一樣, 方便debug
        data_in <= data;
    end
end
endmodule

