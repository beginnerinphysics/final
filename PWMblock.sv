//`include ./DATA_LATCH.sv
//`include ./global_counter.sv
module PWMblock#(parameter DWIDTH = 8)(
 //   input clk,
    input rst,
 //   input start,
    input [DWIDTH-1:0] data,
    input [DWIDTH-1:0] count,
    input hsync,//singal from shreg[8]
    output reg out
);
wire stop, clr;
//shreg[8]進來的時候表示counter從0準備開始數(這是counter設定的);而shreg[8]時, 如果pwm讀到的dataq不是0, 就會先把out設成1, 等到clr==1到out才會變成0
assign stop = ~(|(data ^ count)) ;
assign clr = stop || rst ;
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
//DATA_LATCH #(.STAGE(8), .DWIDTH(8)) u_DATA_LATCH(.clk(clk), .rst(rst), .start(start), .data(data), .data_q(data_q));
//global_counter#(.DWIDTH(8)) outsidecounter(.rst(rst),.clk(clk)),.counter(cntnum));

endmodule
