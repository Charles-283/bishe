`timescale 1ns/100ps

// signal length
`define Col_num_bit 6
`define Col_num     1 << `Col_num_bit
`define Row_num     16
`define Com_leng    32

module MUL_contorller(
    input                       clk,
    input                       rst,
    input                       F,

///////////////////////////////////////////////////////////////
///////////////////  To Superior Controller ///////////////////
// controller interface:External load-store data
    input                       ExLdSt_valid,
    output                      ExLdSt_ready,
    input      [`Com_leng-1:0]  ExLdSt_command,
    inout      [`Row_num-1:0]   ExLdSt_data1,
    inout      [`Row_num-1:0]   ExLdSt_data2,
// controller interface:Compute command
    input                       Compute_valid,
    output                      Compute_ready,//Compute_ready has highest priority,so it always high.
    output reg                  MUL_state,//notice MUL is computing,so dont send next command.
    output                      MUL_finish,//notice MUL is down,so send next command.
    input      [`Com_leng-1:0]  Compute_command,

///////////////////////////////////////////////////////////
///////////////////  To CIM signal list ///////////////////
// response for 'booth encoder input sram' ping-pong read-write
    output     [`Col_num-1:0]   RWWLA,
    inout      [`Row_num-1:0]   RWBLA,
// response for partial-product/addnum1 read to compute unit
    output     [`Col_num-1:0]   RWL_CH1,
// response for Sum(lo)/addnum2 read to compute unit
    output     [`Col_num-1:0]   RWL_CH2,
// response for Sum(hi) read to compute unit
    output     [`Col_num-1:0]   RWL_CH3,

// response for Sum(lo) write to sram
    output     [`Col_num-1:0]   WWL_CH1,
// response for Sum(hi)/external_data write to sram
    output     [`Col_num-1:0]   WWL_CH2,
    output     [`Row_num-1:0]   WBL_CH2,

// response for Sum(hi)/external_data read-write to 'external sram'
    output     [`Col_num-1:0]   RWWL_ExCH1,
    inout      [`Row_num-1:0]   RWBL_ExCH1,
// response for Sum(lo)/external_data read-write to 'external sram'
    output     [`Col_num-1:0]   RWWL_ExCH2,
    inout      [`Row_num-1:0]   RWBL_ExCH2,
    
// compute mode
    output                      Compute_COPY ,
    output                      Compute_AND  ,
    output                      Compute_OR   ,
    output                      Compute_XOR  ,
    output                      Compute_SHIFT,
    output                      Compute_ADD  ,
    output                      Compute_SUB  ,
    output                      Compute_MUL  
    
);
//////////////////////////////////////////////////////
///////////////////  load-store data /////////////////
wire                    RWWLA_CH_wen        = {1{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[20];//write to booth encorder sram
wire [`Col_num_bit-1:0] RWWLA_CH_addr       = {6{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[19:14];
wire                    WWL_CH_wen          = {1{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[13];//normal write channel
wire [`Col_num_bit-1:0] WWL_CH_addr         = {6{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[12:7];
wire                    RWWL_ExCH_ren       = {1{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[6];//read to write other sram
wire                    RWWL_ExCH_wen       = {1{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[5];
wire [`Col_num_bit-2:0] RWWL_ExCH_addr      = {5{ExLdSt_valid & ExLdSt_ready}} & ExLdSt_command[4:0];

assign                  ExLdSt_data1        = RWWL_ExCH_ren ? RWBL_ExCH1 : `Row_num'bz;
assign                  ExLdSt_data2        = RWWL_ExCH_ren ? RWBL_ExCH2 : `Row_num'bz;

wire [`Col_num_bit-1:0] Ex_load_RWWLA_addr  = RWWLA_CH_addr;
wire [`Col_num_bit-1:0] Ex_load_WWL2_addr   = WWL_CH_addr;

//////////////////////////////////////////////////////
///////////////////  Compute /////////////////////////
wire                    Compute_special_mode= {1{Compute_valid & Compute_ready}} & Compute_command[24];//ADD,SUB,MUL need to aviod overflow or not
wire [2:0]              Compute_mode        = {3{Compute_valid & Compute_ready}} & Compute_command[23:21];//COPY,AND,OR,XOR,SHIFT,ADD,SUB,MUL
wire [2:0]              Compute_length      = {3{Compute_valid & Compute_ready}} & Compute_command[20:18];//decide which compute format:int4,8,16,32,64
wire [`Col_num_bit-1:0] Compute_rs1_addr    = {6{Compute_valid & Compute_ready}} & Compute_command[17:12];
wire [`Col_num_bit-1:0] Compute_rs2_addr    = {6{Compute_valid & Compute_ready}} & Compute_command[11: 6];
wire [`Col_num_bit-1:0] Compute_rd_addr     = {6{Compute_valid & Compute_ready}} & Compute_command[ 5: 0];

assign                  Compute_COPY        = (Compute_valid & Compute_ready) & (Compute_mode == 3'b000);
assign                  Compute_AND         = Compute_mode == 3'b001;
assign                  Compute_OR          = Compute_mode == 3'b010;
assign                  Compute_XOR         = Compute_mode == 3'b011;
assign                  Compute_SHIFT       = Compute_mode == 3'b100;
assign                  Compute_ADD         = Compute_mode == 3'b101;
assign                  Compute_SUB         = Compute_mode == 3'b110;
assign                  Compute_MUL         = Compute_mode == 3'b111;

wire [`Col_num_bit-1:0] Compute_RWL1_addr   = Compute_rs1_addr;
wire [`Col_num_bit-1:0] Compute_RWL2_addr   = Compute_rs2_addr;
wire [`Col_num_bit-1:0] Compute_RWL3_addr   = {Compute_rs2_addr[`Col_num_bit-1:1],1'b1};

wire [`Col_num_bit-1:0] Compute_WWL1_addr   = Compute_rd_addr;
wire [`Col_num_bit-1:0] Compute_WWL2_addr   = {Compute_rd_addr[`Col_num_bit-1:1],1'b1};

// reg                     MUL_state           ;
reg  [4:0]              MUL_cycle           ;//intn iterate 2n cycles,so int64 need 32cycles.
wire                    MUL_start           = (MUL_cycle == 5'b0);
assign                  MUL_finish          = (MUL_cycle == (1 << Compute_length));

reg  [`Col_num_bit-1:0] MUL_RWWLA_addr      ;
reg  [`Col_num_bit-2:0] MUL_pingpong_addr1  ;
reg  [`Col_num_bit-2:0] MUL_pingpong_addr2  ;

always @(posedge clk) begin
    if(rst) begin
        MUL_state           <= 1'b0;
        MUL_cycle           <= 5'b0;
        MUL_RWWLA_addr      <= `Col_num_bit'b0;
        MUL_pingpong_addr1  <= `Col_num_bit'b0;
        MUL_pingpong_addr2  <= `Col_num_bit'b0;
    end
    else if(Compute_mode == 3'b111) begin
        MUL_state           <= 1'b1;
        MUL_cycle           <= MUL_cycle + 1'b1;
        MUL_pingpong_addr1  <= MUL_start ? Compute_rs2_addr[5:1] : MUL_pingpong_addr2;
        MUL_pingpong_addr2  <= MUL_start ? Compute_rd_addr[5:1]  : MUL_pingpong_addr1; 
        if (MUL_finish) begin
            MUL_cycle       <= 5'b0;
        end
    end
    else begin
        MUL_state           <= 1'b0;
        MUL_cycle           <= 5'b0;
    end
end

////////////////////////////////////////////////////
///////////////////  Select MUXer  /////////////////
assign ExLdSt_ready = (MUL_state & ((~ExLdSt_command[20]) | (~ExLdSt_command[5]))) | (~MUL_state);
assign Compute_ready = (~(WWL_CH_wen & Compute_command[24])) | 
    (~(RWWLA_CH_wen & ((Compute_command[23:21] == 3'b000) | (Compute_command[23:21] == 3'b101) | (Compute_command[23:21] == 3'b111))));
// addr select
wire [`Col_num_bit-1:0] RWWLA_addr          = ({5{RWWLA_CH_wen}} & Ex_load_RWWLA_addr) | 
                                            ({5{Compute_MUL}} & MUL_RWWLA_addr);
wire [`Col_num_bit-1:0] RWL_CH1_addr        = Compute_RWL1_addr;
wire [`Col_num_bit-1:0] RWL_CH2_addr        = ({5{~Compute_MUL}} & Compute_RWL2_addr) | ({5{Compute_MUL}} & {MUL_pingpong_addr1,1'b0});
wire [`Col_num_bit-1:0] RWL_CH3_addr        = ({5{~Compute_MUL}} & Compute_RWL3_addr) | ({5{Compute_MUL}} & {MUL_pingpong_addr1,1'b1});
wire [`Col_num_bit-1:0] WWL_CH1_addr        = ({5{~Compute_MUL}} & Compute_WWL1_addr) | ({5{Compute_MUL}} & {MUL_pingpong_addr2,1'b0});
wire [`Col_num_bit-1:0] WWL_CH2_addr        = ({5{~Compute_special_mode}} & Compute_WWL2_addr) | ({5{Compute_special_mode}} & {MUL_pingpong_addr2,1'b1}) | ({5{WWL_CH_wen}}   & Ex_load_WWL2_addr);
wire [`Col_num_bit-1:0] RWWL_ExCH1_addr     = {RWWL_ExCH_addr,1'b0};
wire [`Col_num_bit-1:0] RWWL_ExCH2_addr     = {RWWL_ExCH_addr,1'b1};
// external data select
assign                  RWBLA               = RWWLA_CH_wen  ? ExLdSt_data1 : `Row_num'bz;
assign                  WBL_CH2             = WWL_CH_wen    ? ExLdSt_data2 : `Row_num'bz; 
assign                  RWBL_ExCH1          = RWWL_ExCH_wen ? ExLdSt_data1 : `Row_num'bz;
assign                  RWBL_ExCH2          = RWWL_ExCH_wen ? ExLdSt_data2 : `Row_num'bz;
//decoder
decoder decoder_RWWLA       (RWWLA_CH_wen | Compute_MUL, RWWLA_addr, RWWLA);
decoder decoder_RWL1        (Compute_valid & Compute_ready, RWL_CH1_addr, RWL_CH1);
decoder decoder_RWL2        (Compute_AND | Compute_OR | Compute_XOR | Compute_ADD | Compute_SUB | Compute_MUL, RWL_CH2_addr, RWL_CH2);
decoder decoder_RWL3        (Compute_special_mode, RWL_CH3_addr, RWL_CH3);
decoder decoder_WWL1        (Compute_valid & Compute_ready, WWL_CH1_addr, WWL_CH1);
decoder decoder_WWL2        (WWL_CH_wen | Compute_special_mode, WWL_CH2_addr, WWL_CH2);
decoder decoder_RWWLEx1     (RWWL_ExCH_ren | RWWL_ExCH_wen, RWWL_ExCH1_addr, RWWL_ExCH1);
decoder decoder_RWWLEx2     (RWWL_ExCH_ren | RWWL_ExCH_wen, RWWL_ExCH2_addr, RWWL_ExCH2);
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
