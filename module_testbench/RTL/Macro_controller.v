`timescale 1ns/100ps

// signal length
`define Row_num_bit         6
`define Row_num             (1 << `Row_num_bit)
`define Col_num             16

// special address
`define All_zeros_addr      `Row_num_bit'b000000
`define Booth_pipo_addr     `Row_num_bit'b111110
`define MULsum_pipo_addr    `Row_num_bit'b111111

module Macro_controller(
    input                       clk,
    input                       F_in,

///////////////////////////////////////////////////////////////
///////////////////  From Superior Controller ///////////////////
// controller interface:External load-store data
    input                       ExLdSt_valid,//ExLdSt is one cycle command, always ready.
    input      [6:0]            ExLdSt_command,
    input      [`Col_num-1:0]   ExLdSt_wr_data,
    output     [`Col_num-1:0]   ExLdSt_rd_data,
// controller interface:Compute command
    input                       Compute_valid,
    output                      Compute_ready,
    input      [24:0]           Compute_command,

///////////////////////////////////////////////////////////
///////////////////  To CIM signal list ///////////////////
// response for partial-product/addnum1 read to compute unit
    output     [`Row_num-1:0]   RWL_CH1,
// response for Sum(lo)/addnum2 read to compute unit
    output     [`Row_num-1:0]   RWL_CH2,
// response for Sum(hi)/booth_encode_sram read to compute unit/booth_encoder
    output     [`Row_num-1:0]   RWL_CH3,

// response for Sum(lo) write to sram
    output     [`Row_num-1:0]   WWL_CH1,
// response for Sum(hi)/booth_encode_sram write to sram
    output     [`Row_num-1:0]   WWL_CH2,

// response for Sum(hi)/external_data read-write to 'external sram'
    output     [`Row_num-1:0]   RWWL_ExCH,
    output     [`Col_num-1:0]   WBL_ExCH,
    input      [`Col_num-1:0]   RBL_ExCH,
    
// compute control signals
    output                      F_out       ,
    output                      AND_enable  ,
    output                      XOR_enable  ,
    output                      MUL_enable  ,
    output                      Booth_Sel_H ,
    output                      Booth_Sel_L ,
    output                      Booth_wen   ,//write TWO/NEG forcely
    output                      TWO_data    ,//force TWO=1/0
    output                      NEG_data    ,//force NEG=1/0
    output                      ZERO_data   ,//force ZERO=1/0
    output                      Shift       ,
    output                      NShift      ,
    output                      Special_Add 
);
//F through out
assign                  F_out               = F_in         ; 

//////////////////////////////////////////////////////
///////////////////  load-store data /////////////////
assign                  RWWL_ExCH_ren       = {           1{ExLdSt_valid}} & (~ExLdSt_command[6])   ;//read to write other sram
assign                  RWWL_ExCH_wen       = {           1{ExLdSt_valid}} & ExLdSt_command[6]      ;
wire [`Row_num_bit-1:0] RWWL_ExCH_addr      = {`Row_num_bit{ExLdSt_valid}} & ExLdSt_command[5:0]    ;
// external data select
assign                  ExLdSt_rd_data      = {`Col_num{RWWL_ExCH_ren}} & RBL_ExCH                  ;
assign                  WBL_ExCH            = RWWL_ExCH_wen ? ExLdSt_wr_data : `Col_num'bz;

decoder decoder_RWWLEx  (ExLdSt_valid, RWWL_ExCH_addr, RWWL_ExCH);

//////////////////////////////////////////////////////
///////////////////  Compute /////////////////////////
/////////////////// Compute decoder /////////////////////////
wire                    Compute_special_mode= {           1{Compute_valid}} & Compute_command[24];//ADD,SUB need double length,rs1=low/high input(MUL)
wire [2:0]              Compute_mode        = {           3{Compute_valid}} & Compute_command[23:21];//COPY,AND,XOR,SHIFT,ADD,SUB,MUL
wire [2:0]              Compute_length      = {           3{Compute_valid}} & Compute_command[20:18];//decide which compute format:int4,8,16,32,64
wire [`Row_num_bit-1:0] Compute_rs1_addr    = {`Row_num_bit{Compute_valid}} & Compute_command[17:12];
wire [`Row_num_bit-1:0] Compute_rs2_addr    = {`Row_num_bit{Compute_valid}} & Compute_command[11: 6];
wire [`Row_num_bit-1:0] Compute_rd_addr     = {`Row_num_bit{Compute_valid}} & Compute_command[ 5: 0];

wire                    Compute_COPY        = Compute_mode == 3'b001;
wire                    Compute_AND         = Compute_mode == 3'b010;
wire                    Compute_XOR         = Compute_mode == 3'b011;
wire                    Compute_SHIFT       = Compute_mode == 3'b100;
wire                    Compute_ADD         = Compute_mode == 3'b101;
wire                    Compute_SUB         = Compute_mode == 3'b110;
wire                    Compute_MUL         = Compute_mode == 3'b111;

///////////////////  MUL Compute unit /////////////////////////
// MUL state machine
reg  [4:0]              MUL_cycle           ;//intn iterate 2n cycles,so int64 need 32cycles.
wire [4:0]              MUL_cycle_finish    = ({5{Compute_length == 3'b001}} & 5'b00001) |//int4
                                              ({5{Compute_length == 3'b010}} & 5'b00011) |//int8
                                              ({5{Compute_length == 3'b011}} & 5'b00111) |//int16
                                              ({5{Compute_length == 3'b100}} & 5'b01111) |//int32
                                              ({5{Compute_length == 3'b101}} & 5'b11111) ;//int64
wire                    MUL_start           = MUL_cycle == 5'b0;
wire                    MUL_finish          = MUL_cycle == MUL_cycle_finish;
wire                    MUL_counting        = Compute_MUL & (~MUL_finish);

always @(posedge clk)   MUL_cycle           <= MUL_counting ? (MUL_cycle + 1'b1) : 5'b0;
// MUL addr pingpong select
wire [`Row_num_bit-1:0] Compute_MUL_rs1_addr= ({`Row_num_bit{~MUL_cycle[0]                 }}  & Compute_rs1_addr  ) |//0,2,4,6...cycle
                                              ({`Row_num_bit{MUL_cycle[0]                  }}  & `Booth_pipo_addr  ) ;//1,3,5,7...cycle
wire [`Row_num_bit-1:0] Compute_MUL_rd1_addr= ({`Row_num_bit{~MUL_cycle[0]                 }}  & `Booth_pipo_addr  ) |//0,2,4,6...cycle
                                              ({`Row_num_bit{MUL_cycle[0]                  }}  & Compute_rs1_addr  ) ;//1,3,5,7...cycle;

wire [`Row_num_bit-1:0] Compute_MUL_rs3_addr= ({`Row_num_bit{MUL_start                     }}  & `All_zeros_addr   ) |//0 cycle
                                              ({`Row_num_bit{(~MUL_start) | (~MUL_cycle[0])}}  & Compute_rd_addr   ) |//2,4,6...cycle
                                              ({`Row_num_bit{MUL_cycle[0]                  }}  & `MULsum_pipo_addr ) ;//1,3,5,7...cycle
wire [`Row_num_bit-1:0] Compute_MUL_rd2_addr= ({`Row_num_bit{~MUL_cycle[0]                 }}  & `MULsum_pipo_addr ) |//0,2,4,6...cycle
                                              ({`Row_num_bit{MUL_cycle[0]                  }}  & Compute_rd_addr   ) ;//1,3,5,7...cycle;


///////////////////  Compute control signals /////////////////////////
assign                  AND_enable          = Compute_AND                                           ;
assign                  XOR_enable          = Compute_COPY | Compute_XOR | Compute_SHIFT            ;
assign                  MUL_enable          = Compute_MUL                                           ;
assign                  Booth_Sel_H         = Compute_MUL & Compute_special_mode                    ;
assign                  Booth_Sel_L         = Compute_MUL & (~Compute_special_mode)                 ;
assign                  Booth_wen           = ~Compute_MUL                                          ;//write TWO/NEG forcely
assign                  TWO_data            = Compute_SHIFT                                         ;//force TWO=1/0
assign                  NEG_data            = Compute_SUB                                           ;//force NEG=1/0
assign                  ZERO_data           = 1'b0                                                  ;//force TWO=1/0
assign                  Shift               = MUL_counting                                          ;
assign                  NShift              = Compute_ADD | Compute_SUB | (Compute_MUL & MUL_finish);
assign                  Special_Add         = (Compute_ADD | Compute_SUB) & Compute_special_mode    ;

///////////////////  Compute output /////////////////////////
// ready
assign                  Compute_ready       = ~MUL_counting;
// address enable
wire                    RWL_CH1_en          = MUL_enable | Special_Add;
wire                    RWL_CH2_en          = Compute_valid;
wire                    RWL_CH3_en          = Compute_valid;
wire                    WWL_CH1_en          = MUL_enable | Special_Add | AND_enable | XOR_enable;
wire                    WWL_CH2_en          = MUL_enable | Compute_ADD | Compute_SUB ;
// address select
wire [`Row_num_bit-1:0] RWL_CH1_addr        = ({`Row_num_bit{Special_Add               }} & {Compute_rs1_addr[`Row_num_bit-1:1],1'b1}) |
                                              ({`Row_num_bit{MUL_enable                }} & Compute_MUL_rs1_addr   ) ; 
wire [`Row_num_bit-1:0] RWL_CH2_addr        = Compute_rs1_addr                                                       ;
wire [`Row_num_bit-1:0] RWL_CH3_addr        = ({`Row_num_bit{~MUL_enable               }} & Compute_rs2_addr       ) |
                                              ({`Row_num_bit{MUL_enable                }} & Compute_MUL_rs3_addr   ) ;
wire [`Row_num_bit-1:0] WWL_CH1_addr        = ({`Row_num_bit{AND_enable | XOR_enable   }} & Compute_rd_addr        ) | 
                                              ({`Row_num_bit{Compute_MUL               }} & Compute_MUL_rd1_addr   ) |
                                              ({`Row_num_bit{Special_Add               }} & {Compute_rd_addr[`Row_num_bit-1:1],1'b1}) ;
wire [`Row_num_bit-1:0] WWL_CH2_addr        = ({`Row_num_bit{Compute_ADD | Compute_SUB }} & Compute_rd_addr        ) | 
                                              ({`Row_num_bit{Compute_MUL               }} & Compute_MUL_rd2_addr   ) ;
//decoder
decoder decoder_RWL1        (RWL_CH1_en, RWL_CH1_addr, RWL_CH1);
decoder decoder_RWL2        (RWL_CH2_en, RWL_CH2_addr, RWL_CH2);
decoder decoder_RWL3        (RWL_CH3_en, RWL_CH3_addr, RWL_CH3);
decoder decoder_WWL1        (WWL_CH1_en, WWL_CH1_addr, WWL_CH1);
decoder decoder_WWL2        (WWL_CH2_en, WWL_CH2_addr, WWL_CH2);
endmodule


// parameterized decoder
module decoder(
  input wire en,
  input wire [`Row_num_bit-1:0] in, // input binary code
  output wire [`Row_num-1:0] y   // output one-hot code
);

// y is one-hot, so just use shift to finish
assign y = en ? (1 << in) : 0;

endmodule
