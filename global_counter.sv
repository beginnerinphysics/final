module global_counter#(parameter DWIDTH = 8)(
    input rst, //shreg[8]會讓rst歸零
    input clk,
    output [STAGE:0] counter
);
always@(posedge rst or posedge clk)begin
    if(rst) begin
        counter <= 'b0;
    end
    else begin
        counter <= counter+1;
    end
end
endmodule
