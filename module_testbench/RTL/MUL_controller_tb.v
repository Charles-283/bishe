`timescale 1ns/100ps

// clock time
`define period_pos  4
`define period_neg  1
`define F_delay     0.5

// signal length
`define Col_num_bit         6
`define Col_num             (1 << `Col_num_bit)
`define Row_num             16

module MUL_controller_tb(
    output reg                  clk             ,
    output reg                  F_in            ,
///////////////////////////////////////////////////////////////
///////////////////  To Superior Controller ///////////////////
// controller interface:External load-store data
    output reg                  ExLdSt_valid    ,//ExLdSt is one cycle command, always ready.
    output reg [6:0]            ExLdSt_command  ,
    inout      [`Row_num-1:0]   ExLdSt_data     ,
// controller interface:Compute command
    output reg                  Compute_valid   ,
    input                       Compute_ready   ,
    output reg [24:0]           Compute_command 
    
);

//////////////////////////////////////////////////////
///////////////////  Clock Control ///////////////////
initial begin
    clk         =   1'b1;
    F_in        =   1'b1;
end
always begin
    #`period_pos            clk     =   1'b0;
    #`period_neg            clk     =   1'b1;
end
always @(posedge clk) begin
    #`F_delay               F_in    =   1'b1;
    #(`period_pos-`F_delay) F_in    =   1'b0;
end

//////////////////////////////////////////////////////
/////////////////// Command emitter ///////////////////
reg [`Row_num-1:0]   ExLdSt_data_in      ;
reg [`Row_num-1:0]   ExLdSt_data_out     ;
assign ExLdSt_data = ExLdSt_command[6] ? ExLdSt_data_out : 16'hzzzz;


initial begin
    ExLdSt_valid    = 1'b0;
    ExLdSt_command  = 7'b0;
    ExLdSt_data_out = 16'h0;

    Compute_valid   = 1'b0;
    Compute_command = 23'b0;

    // load store test
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b1_000001;
    ExLdSt_data_out = 16'haa55;
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b0_000001;
    ExLdSt_data_in  = ExLdSt_data;

    // load rs1
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b1_000001;
    ExLdSt_data_out = 16'd55;
    // load rs2
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b1_000010;
    ExLdSt_data_out = 16'd110;

    // Compute AND,read rd
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b0_000011;
    ExLdSt_data_out = 16'hzzzz;

    Compute_valid   = 1'b1;
    Compute_command = 25'b0_010_010_000001_000010_000011;//sepc=0,mode=AND,length=int8,rs1=0x1,rs2=0x2,rd=0x3

    // Compute MUL,read rd
    @(posedge clk) ;
    ExLdSt_valid    = 1'b1;
    ExLdSt_command  = 7'b0_000101;
    ExLdSt_data_out = 16'hzzzz;

    Compute_valid   = 1'b1;
    Compute_command = 25'b0_111_010_000001_000010_000101;//sepc=0,mode=MUL,length=int8,rs1=0x1,rs2=0x2,rd=0x3

    @(posedge Compute_ready) ;
    @(posedge clk) ;
    ExLdSt_valid    = 1'b0;
    Compute_valid   = 1'b0;


end

endmodule