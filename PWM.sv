`include "./DATA_LATCH.sv"
`include "./global_counter.sv"
`include "./PWMblock.sv"
module PWM #(parameter DWIDTH = 8, parameter STAGE = 8)(

    input clkfordata,
    input clkforcounter,
    input rst,
    input start,
    input [DWIDTH - 1 : 0] data,

    output reg [0:7] out//////////////////////特別說明一下
);

wire hsync;
wire [DWIDTH - 1 : 0]count;
wire [DWIDTH - 1 : 0] data_q [0 : STAGE -1];
wire rstcnt;

DATA_LATCH DATA_LOADER(.clk(clkfordata), .rst(rst), .start(start), .data(data), .data_q(data_q),.shregforclk(hsync),.resetforcounter(rstcnt));
global_counter counter_instance(.rst(rstcnt),.clk(clkforcounter),.counter(count));//clk的週期要是大週期的DWIDTH分之一,但沒說是多少, 所以就自由設定

genvar i;
generate
    for(i = 0;i < STAGE;i = i + 1)begin:putpwmblock
        PWMblock PWMblockinst(.rst(rst),.data(data_q[i]),.count(count),.out(out[i]),.hsync(hsync));
    end
endgenerate    


endmodule
