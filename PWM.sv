`include "./DATA_LATCH.sv"
`include "./global_counter.sv"
`include "./PWMblock.sv"
module PWM #(parameter DWIDTH = 8, parameter STAGE = 8)(

    input clk,
    input rst,
    input start,
    input [DWIDTH - 1 : 0] data,
//    input [DWIDTH-1:0] count,
//    input hsync,//singal from shreg[8]
    output reg [STAGE - 1 : 0] out
);
reg [DWIDTH - 1 : 0]count;
wire hsync;
wire [DWIDTH - 1 : 0] data_q [0 : STAGE -1];
DATA_LATCH u_DATA_LATCH(.clk(clk), .rst(rst), .start(start), .data(data), .data_q(data_q),.shregforclk(hsync));
global_counter global_counter_instance(.rst(hsync),.clk(clk),.counter(count));//clk的週期要是大週期的DWIDTH分之一,但沒說是多少, 所以就自由設定
genvar i;
generate
    for(i = 0;i < STAGE;i = i + 1)begin:putpwmblock
        PWMblock PWMconnect(.rst(rst),.data(data_q[i]),.count(count),.out(out));
    end
endgenerate    
endmodule
