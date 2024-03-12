//Verilog HDL for "test", "Multiplier_tb" "functional"

`timescale 1ns/1ps
module Multiplier_tb(CLK,WWL1,RWL1,WBL1,WBL1b,F,WWL,RWL,WBL,WBLb,MUL,Shift,NShift,RWWL,RWBL,RWBLb);
output reg  CLK;
output reg  [1:0] WWL1;
output reg  [1:0] RWL1;
output reg  [7:0] WBL1;
output wire [7:0] WBL1b = ~WBL1;//存放加和的单元
output reg        F;//预充电
output reg  [1:0] WWL;
output reg  [1:0] RWL;
output reg  [7:0] WBL;
output wire [7:0] WBLb = ~WBL;/操作，要编码的写入
output reg        MUL;//启动乘法左移一位和编码的左移两位
output reg        Shift;//最后一次求和若要左移两位
output reg        NShift;//最后一次求和直接输出
output reg  RWWL;
output reg  [7:0] RWBL;
output wire [7:0] RWBLb = ~RWBL;//要求部分积的写入
parameter  s0=2'b00 ;
parameter  s1=2'b01 ;
parameter  s2=2'b10 ;
parameter  s3=2'b11 ;
reg        state ;
wire    signed [7:0] out;
wire    signed [3:0] A = WBL[3:0] ;
wire    signed [3:0] B = RWBL[3:0] ;
assign out = A * B;
always begin
    #1 CLK = ~CLK;
    #1 CLK = ~CLK;
end
always begin
    #1.3 F = ~F;
    #0.7 F = ~F;
end
initial begin
    CLK      = 1'b0;
    WWL1     = 2'b11;
    RWL1     = 2'b00;
    WBL1     = 8'b00000000;
    WWL      = 2'b11;
    RWL      = 2'b00;
    WBL      = 8'b00000000;
    state    = s0;
    F        = 1'b0;
    MUL      = 1'b0;
    Shift    = 1'b0;
    NShift   = 1'b0;
    RWWL     = 1'b1;
    RWBL     = 8'b00000000;
end

always @ (posedge CLK)begin
    case (state)
    s0: begin
        state    <= s1;
        WWL1      = 2'b11;
        WBL1      = 8'b00000000;
        WWL       = 2'b10;
        WBL       = $random;
        RWWL      = 1'b1;
        RWBL      = $random;
    end
    s1: begin
        state   <= s2;
        WWL1      = 2'b01;
        RWL1      = 2'b10;
        WWL       = 2'b01;
        RWL       = 2'b10; 
        MUL       = 1'b1;
        Shift     = 1'b1;
        RWWL      = 1'b1;
    end
    s2: begin
        state    <= s0;
        WWL1      = 2'b10;
        RWL1      = 2'b01; 
        WWL       = 2'b10;
        RWL       = 2'b01; 
        MUL       = 1'b1;
        NShift    = 1'b1;
        RWWL      = 1'b1;
    end
    