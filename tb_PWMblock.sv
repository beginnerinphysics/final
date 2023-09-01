`include "./PWMblock.sv"
`include "./global_counter.sv"
`timescale 1ns/1ps
module tb_PWMblock();
reg rst;
reg clk;
reg hsync;
wire [7 : 0] counter;
reg [7:0]data;
wire out;

initial begin
    clk = 0;
    rst = 0;
  //  counter = 0;
    hsync = 0;
    #50 rst = 1;
    #10 data = 20;
    #5  hsync <= 1 ;
    #2  rst <= 0;
    #398 hsync <= 0;
        rst <= 1;
    #1  hsync <= 1;
    #2  rst <=0;
 //   #5  hsync= 0 ;
 //   #5  hsync = 1;
end
always #5 clk <= ~clk ;
global_counter counter_instance(.rst(rst),.clk(clk),.counter(counter));
PWMblock block_instance(.out(out),.rst(rst),.count(counter),.data(data),.hsync(hsync));

endmodule


