`timescale 1ns/1ps
`include "./PWM.sv"
`define PATH "./pattern.txt"
`define CLKFORCOUNTER 2.0
`define CLKFORDATA 64.0
module tb_PWM();

reg clkfordata, clkforcounter, rst, start;
reg [7:0] data;
wire [7:0]out;

reg [7:0] test_data[0:7];
//reg [7:0] test_data;
integer i,a,outtime0,outtime1,outtime2,outtime3,outtime4,outtime5,outtime6,outtime7,input_file;


PWM#(.STAGE(8), .DWIDTH(8)) PWMinstance(.clkfordata(clkfordata),.clkforcounter(clkforcounter),.rst(rst),.start(start),.data(data),.out(out));
/*
initial begin
    $fsdbDumpfile("DATA_LATCH.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;
end
*/
wire [31:0]judge0 = outtime0==test_data[0] ? "right" : "wrong";
wire [31:0]judge1 = outtime1==test_data[1] ? "right" : "wrong";
wire [31:0]judge2 = outtime2==test_data[2] ? "right" : "wrong";
wire [31:0]judge3 = outtime3==test_data[3] ? "right" : "wrong";
wire [31:0]judge4 = outtime4==test_data[4] ? "right" : "wrong";
wire [31:0]judge5 = outtime5==test_data[5] ? "right" : "wrong";
wire [31:0]judge6 = outtime6==test_data[6] ? "right" : "wrong";
wire [31:0]judge7 = outtime7==test_data[7] ? "right" : "wrong";
//---------------------------------------------------------------------
//   CLOCK GENERATION
//---------------------------------------------------------------------
always #(`CLKFORCOUNTER/2.0) clkforcounter = ~clkforcounter;
always #(`CLKFORDATA/2.0) clkfordata = ~clkfordata;
//---------------------------------------------------------------------
//   MAin FLOW
//---------------------------------------------------------------------
always @(posedge PWMinstance.hsync)begin



end
initial begin
	clkfordata = 0;
	clkforcounter = 0;
	rst = 1;
	start = 0;
	data = 'b0;
	#1 rst = 0;
//method 1: direct assign
/*
test_data[0] = 8'h00;
	test_data[1] = 8'h01;
	test_data[2] = 8'h02;
	test_data[3] = 8'h03;
	test_data[4] = 8'h04;
	test_data[5] = 8'h05;
	test_data[6] = 8'h06;
	test_data[7] = 8'h07;
end
*/
//method 2: for loop
/*
	for(i=0;i<8;i=i+1)begin
		if(i==0)begin @(negedge clk); start = 1; data = test_data[i]; end
		else if(i==1)begin @(negedge clk); start = 0; data = test_data[i]; end
		else begin @(negedge clk); data = test_data[i]; end
	end
*/

//method 3: read file
	//$readmemh(`PATH, test_data);

//method 4: read file

	input_file = $fopen(`PATH,"r");
    for(int q=0;q<8;q++) begin
        a = $fscanf(input_file, "%h",test_data[q]);
    end
	force clkforcounter = 0 ;force clkfordata =0;
	reset_signal_task;
	release clkforcounter; release clkfordata; 


	//force data_q[3] = 0; //insert bug

//	@(negedge clk); start = 1; data = test_data;
//	@(negedge clk); start = 0; data = 'h00;



	for(i=0;i<8;i=i+1)begin// already merge the above negedge inside this
		if(i==0)begin @(negedge clkfordata); start = 1; data = test_data[i]; end
		else if(i==1)begin @(negedge clkfordata); start = 0; data = test_data[i]; end
		else begin @(negedge clkfordata); data = test_data[i]; end
	end

    wait(PWMinstance.hsync);
    #1
    outtime_init;
    wait(!(out[0]|out[1]|out[2]|out[3]|out[4]|out[5]|out[6]|out[7]));
$display("it is:%s, out time0 is:%d",judge0 ,outtime0);
$display("it is:%s, out time1 is:%d",judge1 ,outtime1);
$display("it is:%s, out time2 is:%d",judge2 ,outtime2);
$display("it is:%s, out time3 is:%d",judge3 ,outtime3);
$display("it is:%s, out time4 is:%d",judge4 ,outtime4);
$display("it is:%s, out time5 is:%d",judge5 ,outtime5);
$display("it is:%s, out time6 is:%d",judge6 ,outtime6);
$display("it is:%s, out time7 is:%d",judge7 ,outtime7);
	//timer; //insert bug

	@(negedge clkfordata);@(negedge clkfordata);
	$fclose(input_file);
	$finish;
end

//---------------------------------------------------------------------
//   Check and display
//---------------------------------------------------------------------
task reset_signal_task; 
begin 
    rst = 1;
    repeat(2) #(clkfordata); 
    rst = 0;
end 
endtask
always@(posedge clkforcounter)begin
if(out[0]) outtime0=outtime0+1;
if(out[1]) outtime1=outtime1+1;
if(out[2]) outtime2=outtime2+1;
if(out[3]) outtime3=outtime3+1;
if(out[4]) outtime4=outtime4+1;
if(out[5]) outtime5=outtime5+1;
if(out[6]) outtime6=outtime6+1;
if(out[7]) outtime7=outtime7+1;
end
task outtime_init;
    begin
        outtime0 = 0;
        outtime1 = 0;
        outtime2 = 0;
        outtime3 = 0;
        outtime4 = 0;
        outtime5 = 0;
        outtime6 = 0;
        outtime7 = 0;
        if (out[0] == 1) outtime0 = outtime0 + 1;
        if (out[1] == 1) outtime1 = outtime1 + 1;
        if (out[2] == 1) outtime2 = outtime2 + 1;
        if (out[3] == 1) outtime3 = outtime3 + 1;
        if (out[4] == 1) outtime4 = outtime4 + 1;
        if (out[5] == 1) outtime5 = outtime5 + 1;
        if (out[6] == 1) outtime6 = outtime6 + 1;
        if (out[7] == 1) outtime7 = outtime7 + 1;
    end

endtask



//---------------------------------------------------------------------
//   Monitor
//---------------------------------------------------------------------

//================================================================
//                          task
//================================================================


endmodule
/*
module countouttime(
input start,
input clk,
input checktheout,
output outtime
);
reg [8:0]counter;
always@(posedge start or posedge clk)begin
if(start

endmodule
*/
