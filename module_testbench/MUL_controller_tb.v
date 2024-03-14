`include "defines.v"

module MUL_contorller(
    output reg                  clk,
    output reg                  F,
///////////////////////////////////////////////////////////////
///////////////////  To Superior Controller ///////////////////
// controller interface:External load-store data
    output reg                  ExLdSt_valid,//ExLdSt is one cycle command, always ready.
    output reg [6:0]            ExLdSt_command,
    inout      [`Row_num-1:0]   ExLdSt_data,
// controller interface:Compute command
    output reg                  Compute_valid,
    output reg                  Compute_ready,
    output reg [24:0]           Compute_command
    
);

//////////////////////////////////////////////////////
///////////////////  Clock Control ///////////////////
initial begin
    clk =   1'b1;
    F   =   1'b1;
end
always begin
    #`period_pos    clk =   ~clk;
    #`period_neg    clk =   ~clk;
end
always @(posedge clk) begin
    #`F_delay       F   =   ~F;
end

//////////////////////////////////////////////////////
///////////////////  Command emitter ///////////////////





endmodule