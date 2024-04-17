`timescale 1ns/100ps

// signal len
`define Row_num_bit         6
`define Row_num             (1 << `Row_num_bit)
`define Col_num             128
`define Macro_num_bit       3
`define Macro_num           (1 << `Macro_num_bit)

// Main Control parameter
//The depth of the instruction register memory is set to 256 64-bit wide instructions by default.
`define instr_num_bit       8
`define instr_num           (1 << `instr_num_bit)
//Set the number of counters, which is the maximum stack depth. The default is set to eight 10-bit wide counters.
`define counter_num_bit     3
`define counter_num         (1 << `counter_num_bit)
`define counter_len         10
//Set the depth and length of the ddr address register table. By default, eight 25-bit wide ddr addresses can be stored(for 128-bitwidth 512MB DDR3 addressing).
`define ddr_addr_num_bit    3
`define ddr_addr_num        (1 << `ddr_addr_num_bit)
`define ddr_addr_len        25
// Macro mode
`define addr_incr_num_bit   7

module Master_controller(
    input                       clk,
    input                       rst_n,

///////////////////////////////////////////////////////////////
///////////////////  From CPU Peripheral Bus ///////////////////
    input                       CPU_instruction_valid,
    output                      CPU_instruction_irq,//interrupt signal, means finish.
    input   [`instr_num_bit:0]  CPU_instruction_addr,//Because the CPU bus width is 32, it takes 2 cycles to write a full 64-bit instruction.
    input   [31:0]              CPU_instruction_data,

///////////////////////////////////////////////////////////////
///////////////////  From To DDR3-DRAM Interface IP ///////////////////
    output                      DRAM_valid,
    output                      DRAM_wr_en,
    output  [`ddr_addr_len-1:0] DRAM_addr,
    input   [`Col_num-1:0]      DRAM_rd_data,
    output  [`Col_num-1:0]      DRAM_wr_data,

///////////////////////////////////////////////////////////////
///////////////////  To Macro Controller 0 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_0,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_0,
    output  [`Col_num-1:0]      ExLdSt_wr_data_0,
    input   [`Col_num-1:0]      ExLdSt_rd_data_0,
// controller interface:Compute command
    output                      Compute_valid_0,
    input                       Compute_ready_0,
    output  [24:0]              Compute_command_0,
///////////////////  To Macro Controller 1 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_1,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_1,
    output  [`Col_num-1:0]      ExLdSt_wr_data_1,
    input   [`Col_num-1:0]      ExLdSt_rd_data_1,
// controller interface:Compute command
    output                      Compute_valid_1,
    input                       Compute_ready_1,
    output  [24:0]              Compute_command_1,
///////////////////  To Macro Controller 2 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_2,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_2,
    output  [`Col_num-1:0]      ExLdSt_wr_data_2,
    input   [`Col_num-1:0]      ExLdSt_rd_data_2,
// controller interface:Compute command
    output                      Compute_valid_2,
    input                       Compute_ready_2,
    output  [24:0]              Compute_command_2,
///////////////////  To Macro Controller 3 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_3,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_3,
    output  [`Col_num-1:0]      ExLdSt_wr_data_3,
    input   [`Col_num-1:0]      ExLdSt_rd_data_3,
// controller interface:Compute command
    output                      Compute_valid_3,
    input                       Compute_ready_3,
    output  [24:0]              Compute_command_3,
///////////////////  To Macro Controller 4 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_4,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_4,
    output  [`Col_num-1:0]      ExLdSt_wr_data_4,
    input   [`Col_num-1:0]      ExLdSt_rd_data_4,
// controller interface:Compute command
    output                      Compute_valid_4,
    input                       Compute_ready_4,
    output  [24:0]              Compute_command_4,
///////////////////  To Macro Controller 5 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_5,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_5,
    output  [`Col_num-1:0]      ExLdSt_wr_data_5,
    input   [`Col_num-1:0]      ExLdSt_rd_data_5,
// controller interface:Compute command
    output                      Compute_valid_5,
    input                       Compute_ready_5,
    output  [24:0]              Compute_command_5,
///////////////////  To Macro Controller 6 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_6,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_6,
    output  [`Col_num-1:0]      ExLdSt_wr_data_6,
    input   [`Col_num-1:0]      ExLdSt_rd_data_6,
// controller interface:Compute command
    output                      Compute_valid_6,
    input                       Compute_ready_6,
    output  [24:0]              Compute_command_6,
///////////////////  To Macro Controller 7 ///////////////////
// controller interface:External load-store data
    output                      ExLdSt_valid_7,//ExLdSt is one cycle command, always ready.
    output  [6:0]               ExLdSt_command_7,
    output  [`Col_num-1:0]      ExLdSt_wr_data_7,
    input   [`Col_num-1:0]      ExLdSt_rd_data_7,
// controller interface:Compute command
    output                      Compute_valid_7,
    input                       Compute_ready_7,
    output  [24:0]              Compute_command_7
);

////////////////////////////////////////////////////////////////////////////////////////
///////////////////  register table list ///////////////////////////////////////////////////
reg  [63:0]                     instr_table         [0:`instr_num-2]                                ;//The last item as the status_register, controls the start signal(instr_valid)
reg  [1:0]                      status_register                                                     ;//store the instr_valid + finish signal
reg  [`instr_num_bit-1:0]       instr_addr                                                          ;
reg  [`ddr_addr_len-1:0]        ddr_addr_table      [0:`ddr_addr_num-1]                             ;
reg  [`counter_len-1:0]         counter_table       [0:`counter_num-1]                              ;
reg  [`instr_num_bit-1:0]       stack_table         [0:`counter_num-1]                              ;


////////////////////////////////////////////////////////////////////////////////////////
///////////////////  instruction decoder ///////////////////////////////////////////////////
wire                            instr_valid         = status_register[0]                            ;
wire [63:0]                     instruction         = instr_table[instr_addr]                       ;
///////////////////  load register table(LRT) instruction decoder //////////////////////////////////////////
wire                            LRT_instr_valid     = instr_valid & (~instruction[63])              ;//if mode=0,there is load register table.
wire [50:0]                     LRT_instr           = {51{LRT_instr_valid}} & instruction[50:0]     ;

wire                            Ld_stk_cnt_valid    = LRT_instr[50]                                 ;
wire                            Ld_ddr_addr_valid   = LRT_instr[49]                                 ;

wire [`counter_num_bit-1:0]     Ld_stk_cnt_addr     = LRT_instr[48:46]                              ;
wire [`ddr_addr_num_bit-1:0]    Ld_ddr_addr_addr    = LRT_instr[45:43]                              ;

wire [`instr_num_bit-1:0]       Ld_stack            = LRT_instr[42:35]                              ;
wire [`counter_len-1:0]         Ld_counter          = LRT_instr[34:25]                              ;
wire [`ddr_addr_len-1:0]        Ld_ddr_addr         = LRT_instr[24:0]                               ;
///////////////////  Macro instruction decoder ///////////////////////////////////////////////////////////
wire                            Macro_instr_valid   = instr_valid & instruction[63]           ;//if mode=1,there is load DCIM macro and compute.
wire [62:0]                     Macro_instr         = {63{Macro_instr_valid}} & instruction[62:0]   ;

wire                            stk_cnt_valid       = Macro_instr[62]                               ;
wire [`counter_num_bit-1:0]     stk_cnt_addr        = Macro_instr[61:59]                            ;

wire                            addr_incr_valid     = Macro_instr[58]                               ;
wire [`addr_incr_num_bit-1:0]   addr_incr           = Macro_instr[57:51]                            ;

wire                            pipeline_en         = Macro_instr[50]                               ;
wire [1:0]                      pipeline_latency    = Macro_instr[49:48]                            ;

wire [`ddr_addr_num_bit-1:0]    ExLdSt_ddr_addr     = Macro_instr[47:45]                            ;
wire [1:0]                      ExLdSt_macro_selmode= Macro_instr[44:43]                            ;
wire [`Macro_num_bit-1:0]       ExLdSt_macro_sel    = Macro_instr[42:40]                            ;
wire [`Row_num_bit:0]           ExLdSt_command      = Macro_instr[39:33]                            ;

wire [`Macro_num-1:0]           Compute_macro_sel   = Macro_instr[32:25]                            ;
wire [24:0]                     Compute_command     = Macro_instr[24:0]                             ;

////////////////////////////////////////////////////////////////////////////////////////
///////////////////  instruction  //////////////////////////////////////////
// CPU write instruction to instr_table
always @(posedge clk) begin
    if (CPU_instruction_valid)
        if (CPU_instruction_addr[0])
            instr_table[CPU_instruction_addr[`instr_num_bit:1]][31: 0] <= CPU_instruction_data      ;
        else                                                    
            instr_table[CPU_instruction_addr[`instr_num_bit:1]][63:32] <= CPU_instruction_data      ;
end
// instruction start excution and finish
assign                          CPU_instruction_irq = status_register[1]                            ;
always @(posedge clk) begin
    if (|CPU_instruction_addr | instruction[63:62] == 2'b01) begin//when in LRT mode and instr[62]=1,there means finish signal.
        status_register[0] <= ((|CPU_instruction_addr) & CPU_instruction_data[0])                   ;//when instr_addr=all_1,write instr_valid(start) signal
        status_register[1] <= (instruction[63:62] == 2'b01)                                         ;
    end
end
// instruction counter(similar to the PC of CPU) increment and Loop Branch
wire                            counter_all_zero    = (counter_table[stk_cnt_addr] == `counter_len'b0);
wire                            counting            = stk_cnt_valid & (~counter_all_zero)           ;
always @(posedge clk) begin
    if (~rst_n) 
        instr_addr <= `instr_num_bit'b0                                                             ;
    else if (counting)
        instr_addr <= stack_table[stk_cnt_addr]                                                     ;
    else if (instr_valid)
        instr_addr <= (instr_addr + 1'b1)                                                           ;
end


////////////////////////////////////////////////////////////////////////////////////////
///////////////////  load register table(LRT) mode ///////////////////////////////////// 
// load register table
always @(posedge clk) begin
    if (Ld_stk_cnt_valid)
        stack_table     [Ld_stk_cnt_addr]   <= Ld_stack                                             ;
    
    if(counting)    
        counter_table   [stk_cnt_addr]      <= counter_table[stk_cnt_addr] - 1'b1                   ;
    else if (Ld_stk_cnt_valid)
        counter_table   [Ld_stk_cnt_addr]   <= Ld_counter                                           ;

    if(addr_incr_valid)
        ddr_addr_table  [ExLdSt_ddr_addr]   <= ddr_addr_table[ExLdSt_ddr_addr] + addr_incr          ;
    else if (Ld_ddr_addr_valid) 
        ddr_addr_table  [Ld_ddr_addr_addr]  <= Ld_ddr_addr                                          ;
end


////////////////////////////////////////////////////////////////////////////////////////
///////////////////  Macro mode ////////////////////////////////////////////////////////
///////////////////  pipeline technique  //////////////////////////////////////////
reg  [33:0]                     command_pipeline_reg    [0:(`Macro_num-2)]                                       ;//ExLdSt_command_7bits+Compute_command_25bits=32bits+2bits=34bits
wire                            ExLdSt_pipe_valid   = (ExLdSt_macro_selmode == 2'b01)               ;
wire                            Compute_pipe_valid  = Compute_macro_sel[0]                          ;

reg  [1:0]                      pipeline_counter                                                    ;
wire                            pipeline_cnt_match  = (pipeline_counter == pipeline_latency)        ;
always @(posedge clk) begin
    if (~rst_n) begin
        pipeline_counter <= 3'b0                                                                    ;
        for (integer i=0; i<(`Macro_num-1); i=i+1) begin
            command_pipeline_reg[i] <= 34'b0                                                        ;
        end
    end
    else if (pipeline_en) begin
        pipeline_counter <= pipeline_cnt_match ? 2'b0 : pipeline_counter + 1'b1 ;
        if (pipeline_cnt_match) begin
            command_pipeline_reg[0] <= {ExLdSt_pipe_valid,ExLdSt_command,Compute_pipe_valid,Compute_command};
            for (integer i=0; i<(`Macro_num-2); i=i+1) begin
                command_pipeline_reg[i+1] <= command_pipeline_reg[i]                                        ;
            end
        end
    end
end


////////////////////////////////////////////////////////////////////////////////////////
///////////////////  ExLdSt Command  //////////////////////////////////////////
wire [`Macro_num-1:0]           ExLdSt_valid_pipe   = {ExLdSt_pipe_valid                            ,
                                                       command_pipeline_reg[0][33]                  ,
                                                       command_pipeline_reg[1][33]                  ,
                                                       command_pipeline_reg[2][33]                  ,
                                                       command_pipeline_reg[3][33]                  ,
                                                       command_pipeline_reg[4][33]                  ,
                                                       command_pipeline_reg[5][33]                  ,
                                                       command_pipeline_reg[6][33]                  };
wire                            ExLdSt_valid        = (ExLdSt_macro_selmode != 2'b00) | (|({`Macro_num{pipeline_en}} & ExLdSt_valid_pipe));
wire [`Macro_num-1:0]           ExLdSt_sel_single   = {`Macro_num{ExLdSt_macro_selmode == 2'b01}} | ({`Macro_num{pipeline_en}} & ExLdSt_valid_pipe);
wire                            ExLdSt_sel_spfull   = (ExLdSt_macro_selmode == 2'b10)               ; 
wire                            ExLdSt_sel_full     = (ExLdSt_macro_selmode == 2'b11)               ; 
wire                            ExLdSt_single_sel_0 = (ExLdSt_macro_sel == 3'b000)                  ;
wire                            ExLdSt_single_sel_1 = (ExLdSt_macro_sel == 3'b001) | (pipeline_en & command_pipeline_reg[0][33]);
wire                            ExLdSt_single_sel_2 = (ExLdSt_macro_sel == 3'b010) | (pipeline_en & command_pipeline_reg[1][33]);
wire                            ExLdSt_single_sel_3 = (ExLdSt_macro_sel == 3'b011) | (pipeline_en & command_pipeline_reg[2][33]);
wire                            ExLdSt_single_sel_4 = (ExLdSt_macro_sel == 3'b100) | (pipeline_en & command_pipeline_reg[3][33]);
wire                            ExLdSt_single_sel_5 = (ExLdSt_macro_sel == 3'b101) | (pipeline_en & command_pipeline_reg[4][33]);
wire                            ExLdSt_single_sel_6 = (ExLdSt_macro_sel == 3'b110) | (pipeline_en & command_pipeline_reg[5][33]);
wire                            ExLdSt_single_sel_7 = (ExLdSt_macro_sel == 3'b111) | (pipeline_en & command_pipeline_reg[6][33]);
wire [6:0]                      ExLdSt_single_command_0= ExLdSt_command                             ;
wire [6:0]                      ExLdSt_single_command_1= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[0][32:26]);
wire [6:0]                      ExLdSt_single_command_2= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[1][32:26]);
wire [6:0]                      ExLdSt_single_command_3= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[2][32:26]);
wire [6:0]                      ExLdSt_single_command_4= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[3][32:26]);
wire [6:0]                      ExLdSt_single_command_5= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[4][32:26]);
wire [6:0]                      ExLdSt_single_command_6= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[5][32:26]);
wire [6:0]                      ExLdSt_single_command_7= ExLdSt_command | ({7{pipeline_en}} & command_pipeline_reg[6][32:26]);
///////////////////  Macro 0-7 ExLdSt Command  //////////////////////////////////////////
// valid signal
wire [`Macro_num-1:0]           ExLdSt_valid_single = {ExLdSt_single_sel_0,
                                                       ExLdSt_single_sel_1,
                                                       ExLdSt_single_sel_2,
                                                       ExLdSt_single_sel_3,
                                                       ExLdSt_single_sel_4,
                                                       ExLdSt_single_sel_5,
                                                       ExLdSt_single_sel_6,
                                                       ExLdSt_single_sel_7};
assign                          {ExLdSt_valid_0,
                                 ExLdSt_valid_1,
                                 ExLdSt_valid_2,
                                 ExLdSt_valid_3,
                                 ExLdSt_valid_4,
                                 ExLdSt_valid_5,
                                 ExLdSt_valid_6,
                                 ExLdSt_valid_7}    = (ExLdSt_sel_single & ExLdSt_valid_single)   | 
                                                      ({`Macro_num{ExLdSt_sel_spfull | ExLdSt_sel_full}})       ;
// command signal
wire [`Macro_num*(`Row_num_bit+1)-1:0]ExLdSt_command_single={({(`Row_num_bit+1){ExLdSt_sel_single[7] & ExLdSt_single_sel_0}} & ExLdSt_single_command_0)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[6] & ExLdSt_single_sel_1}} & ExLdSt_single_command_1)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[5] & ExLdSt_single_sel_2}} & ExLdSt_single_command_2)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[4] & ExLdSt_single_sel_3}} & ExLdSt_single_command_3)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[3] & ExLdSt_single_sel_4}} & ExLdSt_single_command_4)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[2] & ExLdSt_single_sel_5}} & ExLdSt_single_command_5)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[1] & ExLdSt_single_sel_6}} & ExLdSt_single_command_6)    ,
                                                             ({(`Row_num_bit+1){ExLdSt_sel_single[0] & ExLdSt_single_sel_7}} & ExLdSt_single_command_7)}   ;
assign                          {ExLdSt_command_0,
                                 ExLdSt_command_1,
                                 ExLdSt_command_2,
                                 ExLdSt_command_3,
                                 ExLdSt_command_4,
                                 ExLdSt_command_5,
                                 ExLdSt_command_6,
                                 ExLdSt_command_7}  = ExLdSt_command_single |
                                                      ({(`Macro_num*(`Row_num_bit+1)){ExLdSt_sel_spfull | ExLdSt_sel_full}} & {`Macro_num{ExLdSt_command}});
// rd_data signal
wire [`Macro_num*`Col_num-1:0]  DRAM_rd_data_single = {({`Col_num{ExLdSt_sel_single[7] & ExLdSt_single_sel_0}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[6] & ExLdSt_single_sel_1}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[5] & ExLdSt_single_sel_2}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[4] & ExLdSt_single_sel_3}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[3] & ExLdSt_single_sel_4}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[2] & ExLdSt_single_sel_5}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[1] & ExLdSt_single_sel_6}} & DRAM_rd_data)  ,
                                                       ({`Col_num{ExLdSt_sel_single[0] & ExLdSt_single_sel_7}} & DRAM_rd_data)} ;  
wire [`Macro_num*`Col_num-1:0]  DRAM_rd_data_spfull = {{`Macro_num{DRAM_rd_data[127:112]}}          ,
                                                       {`Macro_num{DRAM_rd_data[111: 96]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 95: 80]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 79: 64]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 63: 48]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 47: 32]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 31: 16]}}          ,
                                                       {`Macro_num{DRAM_rd_data[ 15:  0]}}}         ;  
wire [`Macro_num*`Col_num-1:0]  DRAM_rd_data_full   = {`Macro_num{DRAM_rd_data}}                    ;
assign                          {ExLdSt_wr_data_0,
                                 ExLdSt_wr_data_1,
                                 ExLdSt_wr_data_2,
                                 ExLdSt_wr_data_3,
                                 ExLdSt_wr_data_4,
                                 ExLdSt_wr_data_5,
                                 ExLdSt_wr_data_6,
                                 ExLdSt_wr_data_7}  = DRAM_rd_data_single | 
                                                      ({(`Macro_num*`Col_num){ExLdSt_sel_spfull}} & DRAM_rd_data_spfull) |
                                                      ({(`Macro_num*`Col_num){ExLdSt_sel_full  }} & DRAM_rd_data_full  ) ;
///////////////////  DRAM Interface  //////////////////////////////////////////
assign                          DRAM_valid          = ExLdSt_valid                                  ;
wire                            ExLdSt_wr_en_pipe   = command_pipeline_reg[0][32]                   |
                                                      command_pipeline_reg[1][32]                   |
                                                      command_pipeline_reg[2][32]                   |
                                                      command_pipeline_reg[3][32]                   |
                                                      command_pipeline_reg[4][32]                   |
                                                      command_pipeline_reg[5][32]                   |
                                                      command_pipeline_reg[6][32]                   ;
assign                          DRAM_wr_en          = ~((ExLdSt_command[`Row_num_bit]) | (pipeline_en & ExLdSt_wr_en_pipe));
assign                          DRAM_addr           = ddr_addr_table[ExLdSt_ddr_addr]               ;
wire [`Col_num-1:0]             DRAM_wr_data_single = ({`Col_num{ExLdSt_single_sel_0}} & ExLdSt_rd_data_0) |
                                                      ({`Col_num{ExLdSt_single_sel_1}} & ExLdSt_rd_data_1) |
                                                      ({`Col_num{ExLdSt_single_sel_2}} & ExLdSt_rd_data_2) |
                                                      ({`Col_num{ExLdSt_single_sel_3}} & ExLdSt_rd_data_3) |
                                                      ({`Col_num{ExLdSt_single_sel_4}} & ExLdSt_rd_data_4) |
                                                      ({`Col_num{ExLdSt_single_sel_5}} & ExLdSt_rd_data_5) |
                                                      ({`Col_num{ExLdSt_single_sel_6}} & ExLdSt_rd_data_6) |
                                                      ({`Col_num{ExLdSt_single_sel_7}} & ExLdSt_rd_data_7) ;
assign                          DRAM_wr_data        = {`Col_num{DRAM_wr_en}} & DRAM_wr_data_single ;


////////////////////////////////////////////////////////////////////////////////////////
///////////////////  Compute Macro 0-7 Command  //////////////////////////////////////////
// valid signal
wire [`Macro_num-1:0]           Compute_valid_pipe  = {Compute_macro_sel[0]       ,
                                                       command_pipeline_reg[0][25],
                                                       command_pipeline_reg[1][25],
                                                       command_pipeline_reg[2][25],
                                                       command_pipeline_reg[3][25],
                                                       command_pipeline_reg[4][25],
                                                       command_pipeline_reg[5][25],
                                                       command_pipeline_reg[6][25]};
assign                          {Compute_valid_0,
                                 Compute_valid_1,
                                 Compute_valid_2,
                                 Compute_valid_3,
                                 Compute_valid_4,
                                 Compute_valid_5,
                                 Compute_valid_6,
                                 Compute_valid_7}   = pipeline_en ? Compute_valid_pipe : Compute_macro_sel;
// command signal
wire [`Macro_num*25-1:0]        Compute_command_pipe= {Compute_command              ,
                                                       command_pipeline_reg[0][24:0],
                                                       command_pipeline_reg[1][24:0],
                                                       command_pipeline_reg[2][24:0],
                                                       command_pipeline_reg[3][24:0],
                                                       command_pipeline_reg[4][24:0],
                                                       command_pipeline_reg[5][24:0],
                                                       command_pipeline_reg[6][24:0]};
assign                          {Compute_command_0,
                                 Compute_command_1,
                                 Compute_command_2,
                                 Compute_command_3,
                                 Compute_command_4,
                                 Compute_command_5,
                                 Compute_command_6,
                                 Compute_command_7} = pipeline_en ? Compute_command_pipe : Compute_command;

endmodule