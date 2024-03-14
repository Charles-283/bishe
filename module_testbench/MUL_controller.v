`include "defines.v"

module MUL_contorller(
    input                       clk,
    input                       F_in,

///////////////////////////////////////////////////////////////
///////////////////  To Superior Controller ///////////////////
// controller interface:External load-store data
    input                       ExLdSt_valid,//ExLdSt is one cycle command, always ready.
    input      [6:0]            ExLdSt_command,
    inout      [`Row_num-1:0]   ExLdSt_data,
// controller interface:Compute command
    input                       Compute_valid,
    output                      Compute_ready,
    input      [24:0]           Compute_command,

///////////////////////////////////////////////////////////
///////////////////  To CIM signal list ///////////////////
// response for partial-product/addnum1 read to compute unit
    output     [`Col_num-1:0]   RWL_CH1,
// response for Sum(lo)/addnum2 read to compute unit
    output     [`Col_num-1:0]   RWL_CH2,
// response for Sum(hi)/booth_encode_sram read to compute unit/booth_encoder
    output     [`Col_num-1:0]   RWL_CH3,

// response for Sum(lo) write to sram
    output     [`Col_num-1:0]   WWL_CH1,
// response for Sum(hi)/booth_encode_sram write to sram
    output     [`Col_num-1:0]   WWL_CH2,

// response for Sum(hi)/external_data read-write to 'external sram'
    output     [`Col_num-1:0]   RWWL_ExCH,
    inout      [`Row_num-1:0]   RWBL_ExCH,
    output                      RWWL_ExCH_wen,//if 0,read from sram
    output                      RWWL_ExCH_ren,//if 0,read from sram
    
// compute control signals
    output                       F_out
    // output                      AND_enable   ,
    // output                      XOR_enable   ,
    // output                      Select_Carrylo_HA,//select WWL_CH1 trans sum(lo) or HA
    // output                      Select_Carryhi_Shift2,//select WWL_CH2 trans sum(hi) or booth<<2 
    // output                      TWO_wen,//force TWO to realize copy or shift 1bit
    // output                      TWO_data,//force TWO=1/0
    // output                      booth_shift2_en

    
);
//////////////////////////////////////////////////////
///////////////////  load-store data /////////////////
assign                  RWWL_ExCH_ren       = {             1{ExLdSt_valid}} & (~ExLdSt_command[6]);//read to write other sram
assign                  RWWL_ExCH_wen       = {             1{ExLdSt_valid}} & ExLdSt_command[6];
wire [`Col_num_bit-1:0] RWWL_ExCH_addr      = {(`Col_num_bit){ExLdSt_valid}} & ExLdSt_command[5:0];
// external data select
assign                  ExLdSt_data         = RWWL_ExCH_ren ? RWBL_ExCH     : `Row_num'bz;
assign                  RWBL_ExCH           = RWWL_ExCH_wen ? ExLdSt_data   : `Row_num'bz;

decoder decoder_RWWLEx  (ExLdSt_valid, RWWL_ExCH_addr, RWWL_ExCH);

//////////////////////////////////////////////////////
///////////////////  Compute /////////////////////////
/////////////////// Compute decoder /////////////////////////
wire                    Compute_special_mode= {             1{Compute_valid}} & Compute_command[24];//ADD,SUB need double length,force TWO=1
wire [2:0]              Compute_mode        = {             3{Compute_valid}} & Compute_command[23:21];//AND,XOR,SHIFT,ADD,SUB,MUL
wire [2:0]              Compute_length      = {             3{Compute_valid}} & Compute_command[20:18];//decide which compute format:int4,8,16,32,64
wire [`Col_num_bit-1:0] Compute_rs1_addr    = {(`Col_num_bit){Compute_valid}} & Compute_command[17:12];
wire [`Col_num_bit-1:0] Compute_rs2_addr    = {(`Col_num_bit){Compute_valid}} & Compute_command[11: 6];
wire [`Col_num_bit-1:0] Compute_rd_addr     = {(`Col_num_bit){Compute_valid}} & Compute_command[ 5: 0];

assign                  Compute_AND         = Compute_mode == 3'b001;
assign                  Compute_XOR         = Compute_mode == 3'b010;
assign                  Compute_SHIFT       = Compute_mode == 3'b011;
assign                  Compute_ADD         = Compute_mode == 3'b100;
assign                  Compute_SUB         = Compute_mode == 3'b101;
assign                  Compute_MUL         = Compute_mode == 3'b110;

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

// Compute control signals






// MUL addr pingpong select
wire [`Col_num_bit-1:0] Compute_MUL_rs1_addr= ({(`Col_num_bit){MUL_start                     }}  & `All_zeros_addr   ) |//0 cycle
                                              ({(`Col_num_bit){(~MUL_start) | (~MUL_cycle[0])}}  & Compute_rd_addr   ) |//2,4,6...cycle
                                              ({(`Col_num_bit){MUL_cycle[0]                  }}  & `MULsum_pipo_addr ) ;//1,3,5,7...cycle
wire [`Col_num_bit-1:0] Compute_MUL_rd1_addr= ({(`Col_num_bit){~MUL_cycle[0]                 }}  & `MULsum_pipo_addr ) |//0,2,4,6...cycle
                                              ({(`Col_num_bit){MUL_cycle[0]                  }}  & Compute_rd_addr   ) ;//1,3,5,7...cycle;

wire [`Col_num_bit-1:0] Compute_MUL_rs3_addr= ({(`Col_num_bit){~MUL_cycle[0]                 }}  & Compute_rs1_addr  ) |//0,2,4,6...cycle
                                              ({(`Col_num_bit){MUL_cycle[0]                  }}  & `Booth_pipo_addr  ) ;//1,3,5,7...cycle
wire [`Col_num_bit-1:0] Compute_MUL_rd2_addr= ({(`Col_num_bit){~MUL_cycle[0]                 }}  & `Booth_pipo_addr  ) |//0,2,4,6...cycle
                                              ({(`Col_num_bit){MUL_cycle[0]                  }}  & Compute_rs1_addr  ) ;//1,3,5,7...cycle;

///////////////////  MUL Compute output /////////////////////////
// ready
assign                  Compute_ready       = ~MUL_counting;
// address enable
wire                    RWL_CH1_en          = Compute_valid & (~Compute_SHIFT);
wire                    RWL_CH2_en          = Compute_valid & (~Compute_SHIFT);
wire                    RWL_CH3_en          = Compute_MUL | Compute_SHIFT | Compute_ADD | Compute_SUB;
wire                    WWL_CH1_en          = Compute_valid & (~Compute_SHIFT);
wire                    WWL_CH2_en          = Compute_valid & (~(Compute_AND | Compute_XOR));
// address select
wire [`Col_num_bit-1:0] RWL_CH1_addr        = ({(`Col_num_bit){Compute_MUL               }} & Compute_MUL_rs1_addr   ) | 
                                              ({(`Col_num_bit){~Compute_MUL              }} & Compute_rs1_addr       ) ;
wire [`Col_num_bit-1:0] RWL_CH2_addr        = Compute_rs2_addr                                            ;
wire [`Col_num_bit-1:0] RWL_CH3_addr        = ({(`Col_num_bit){Compute_MUL               }} & Compute_MUL_rs3_addr   ) | 
                                              ({(`Col_num_bit){Compute_SHIFT             }} & Compute_rs1_addr       ) | 
                                              ({(`Col_num_bit){Compute_ADD | Compute_SUB }} & {Compute_rs2_addr[`Col_num_bit-1:1],1'b1}) ;
wire [`Col_num_bit-1:0] WWL_CH1_addr        = ({(`Col_num_bit){Compute_MUL               }} & Compute_MUL_rd1_addr   ) | 
                                              ({(`Col_num_bit){~Compute_MUL              }} & Compute_rd_addr        ) ;
wire [`Col_num_bit-1:0] WWL_CH2_addr        = ({(`Col_num_bit){Compute_MUL               }} & Compute_MUL_rd2_addr   ) | 
                                              ({(`Col_num_bit){Compute_SHIFT             }} & Compute_rd_addr        ) | 
                                              ({(`Col_num_bit){Compute_ADD | Compute_SUB }} & {Compute_rd_addr[`Col_num_bit-1:1],1'b1}) ;
//decoder
decoder decoder_RWL1        (RWL_CH1_en, RWL_CH1_addr, RWL_CH1);
decoder decoder_RWL2        (RWL_CH2_en, RWL_CH2_addr, RWL_CH2);
decoder decoder_RWL3        (RWL_CH3_en, RWL_CH3_addr, RWL_CH3);
decoder decoder_WWL1        (WWL_CH1_en, WWL_CH1_addr, WWL_CH1);
decoder decoder_WWL2        (WWL_CH2_en, WWL_CH2_addr, WWL_CH2);

//F through out
assign                  F_out               = F_in         ; 
endmodule


// parameterized decoder
module decoder(
  input wire en,
  input wire [`Col_num_bit-1:0] in, // input binary code
  output wire [`Col_num-1:0] y   // output one-hot code
);

// y is one-hot, so just use shift to finish
assign y = en ? (1 << in) : 0;

endmodule
