`timescale 1ns/100ps

// signal length
`define Col_num_bit 6
`define Col_num     1 << `Col_num_bit
`define Row_num     16
`define Com_leng    32
// clock time
`define period_pos  4
`define period_neg  1
`define F_delay     0.5

module MUL_contorller(
    output reg          clk,
    output reg          F
);


//////////////////////////////////////////////////////
///////////////////  Clock Control ///////////////////
reg     rst;
initial begin
    clk =   1'b1;
    F   =   1'b1;
    rst =   1'b1;
    #10
    rst =   1'b0;
end
always begin
    #`period_pos    clk =   ~clk;
    #`period_neg    clk =   ~clk;
end
always @(posedge clk) begin
    #`F_delay       F   =   ~F;
end

endmodule