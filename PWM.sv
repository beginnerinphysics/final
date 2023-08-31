`include ./DATA_LATCH.sv
`include ./global_counter.sv
`include ./PWMblock.sv
module PWM #(parameter DWIDTH = 8, parameter STAGE = 8)(

    input clk,
    input rst,
    input start,
    input [DWIDTH-1:0] data,
//    input [DWIDTH-1:0] count,
    input hsync,//singal from shreg[8]
    output reg [STAGE-1:0]out
)
genvar i;
generate
    for(i=0;i<STAGE;i=i+1)begin:pwmblock
    
endgenerate    
endmodule
