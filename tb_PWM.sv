`timescale 1ns/1ps
`include "./PWM.sv"
`define PATH "./pattern.txt"
`define CLKFORCOUNTER 1.0
`define CLKFORDATA 33.0
module tb_PWM();

reg clkfordata, clkforcounter, rst, start;
reg [7:0] data;
wire [7:0]out;

reg [7:0] test_data[0:7];
//reg [7:0] test_data;
integer i,a,errornum,input_file;


PWM#(.STAGE(8), .DWIDTH(8)) PWMinstance(.clkfordata(clkfordata),.clkforcounter(clkforcounter),.rst(rst),.start(start),.data(data),.out(out));
/*
initial begin
    $fsdbDumpfile("DATA_LATCH.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;
end
*/
wire [31:0]judge= errornum?"wrong":"right";
//---------------------------------------------------------------------
//   CLOCK GENERATION
//---------------------------------------------------------------------
always #(`CLKFORCOUNTER/2.0) clkforcounter = ~clkforcounter;
always #(`CLKFORDATA/2.0) clkfordata = ~clkfordata;
//---------------------------------------------------------------------
//   MAin FLOW
//---------------------------------------------------------------------
initial begin
	clkfordata = 0;
	clkforcounter = 0;
	rst = 1;
	start = 0;
	data = 'b0;
	errornum = 0;
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
/*
task check_output;
begin

$display("it is:%s",judge);
end
endtask
*/

//---------------------------------------------------------------------
//   Monitor
//---------------------------------------------------------------------

//================================================================
//                          task
//================================================================


endmodule
