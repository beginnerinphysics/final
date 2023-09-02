module DATA_LATCH#(parameter STAGE = 8, parameter DWIDTH = 8)(
    input clk,
    input rst,
    input start,
    input  [DWIDTH-1:0] data,
    output reg [DWIDTH-1:0] data_q[0:STAGE-1],
    output shregforclk,
    output resetforcounter
    /*
    output [DWIDTH-1:0] data_q1,
    output [DWIDTH-1:0] data_q2,
    output [DWIDTH-1:0] data_q3,
    output [DWIDTH-1:0] data_q4,
    output [DWIDTH-1:0] data_q5,
    output [DWIDTH-1:0] data_q6,
    output [DWIDTH-1:0] data_q7,
    output [DWIDTH-1:0] data_q8
    */
);
reg [STAGE : 0] shreg;
assign shregforclk = shreg[STAGE];//pull out last shreg for triggering
//reg [DWIDTH-1:0] data_in[0:STAGE-1];
assign resetforcounter = shreg[STAGE-1];
always@(posedge clk or posedge rst)begin
    if(rst)begin
        shreg <= 'b0;
    end
    else begin
        shreg <= {shreg[STAGE-1:0],start};
    end
end
genvar i;
generate
    for(i=0;i<STAGE;i=i+1)begin: DATA_SHIFT
   //     if(i==0)begin: DATA_SHIFT_0
        always@(posedge shreg[i] or posedge rst)begin
            if(rst)begin
                data_q[i] <= 'b0;
            end
            else begin
                data_q[i] <= data;
            end
        end
/*
        always@(posedge shreg[STAGE] or posedge rst)begin
            if(rst)begin
                data_q[i] <= 'b0;
            end
            else begin
                data_q[i] <=data_in[i];
            end
    end
*/ 
   /*
        else begin: DATA_SHIFT_1to7
            always@(posedge shreg[i] or posedge rst)begin
                if(rst)begin
                    data_q[i] <= 'b0;
                end
                else begin
                    //data_q[i] <= data_q[i-1];
                    data_q[i] <= data;
                end
            end
        end
   */
    end
endgenerate


endmodule
