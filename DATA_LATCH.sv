module DATA_LATCH#(parameter STAGE = 8, parameter DWIDTH = 8)(
    input clk,
    input rst,
    input start,
    input  [DWIDTH-1:0] data,
    output reg [DWIDTH-1:0] data_q[0:STAGE-1],
    output shregforclk,
    output resetforcounter

);
reg [STAGE : 0] shreg;
//reg [DWIDTH-1:0] data_in[0:STAGE-1];
assign shregforclk = shreg[STAGE];
assign resetforcounter = shreg[STAGE-1];
always@(posedge clk or posedge rst)begin
    if(rst)begin
        shreg <= 'b0;
    end
    else if(shreg != 9'b0100_0000_0) begin
        shreg <= {shreg[STAGE-1:0],start};
    end
    else begin
        shreg[0] <= 1 ;
        shreg[8] <= 1 ;
    end
end
genvar i;
generate
    for(i=0;i<STAGE;i=i+1)begin: DATA_SHIFT
        always@(posedge shreg[i] or posedge rst)begin
            if(rst)begin
               // data_in[i] <= 'b0;
                data_q[i] <= 'b0;
            end
            else begin
                //data_in[i] <= data;
                data_q[i] <= data;
            end
        end
    end
endgenerate
endmodule
