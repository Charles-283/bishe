`timescale 1ns/100ps

// signal length
`define Row_num_bit         6
`define Row_num             (1 << `Row_num_bit)
`define Col_num             16
// Main Control parameter
//The depth of the instruction register memory is set to 256 64-bit wide instructions by default.
`define instr_num_bit       8
//Set the depth and length of the ddr address register table. By default, eight 25-bit wide ddr addresses can be stored(for 128-bitwidth 512MB DDR3 addressing).
`define ddr_addr_len        25

module top_tb;   

// Master_controller Inputs
wire  clk                                  ;
wire  rst_n                                ;
wire  CPU_instruction_valid                ;
wire  [`instr_num_bit:0]  CPU_instruction_addr ;
wire  [31:0]  CPU_instruction_data         ;
wire  [`Col_num-1:0]  DRAM_rd_data         ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_0     ;
wire  Compute_ready_0                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_1     ;
wire  Compute_ready_1                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_2     ;
wire  Compute_ready_2                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_3     ;
wire  Compute_ready_3                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_4     ;
wire  Compute_ready_4                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_5     ;
wire  Compute_ready_5                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_6     ;
wire  Compute_ready_6                      ;
wire  [`Col_num-1:0]  ExLdSt_rd_data_7     ;
wire  Compute_ready_7                      ;

// Master_controller Outputs
wire  CPU_instruction_irq                  ;
wire  DRAM_valid                           ;
wire  DRAM_wr_en                           ;
wire  [`ddr_addr_len-1:0]  DRAM_addr       ;
wire  [`Col_num-1:0]  DRAM_wr_data         ;
wire  ExLdSt_valid_0                       ;
wire  [6:0]  ExLdSt_command_0              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_0     ;
wire  Compute_valid_0                      ;
wire  [24:0]  Compute_command_0            ;
wire  ExLdSt_valid_1                       ;
wire  [6:0]  ExLdSt_command_1              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_1     ;
wire  Compute_valid_1                      ;
wire  [24:0]  Compute_command_1            ;
wire  ExLdSt_valid_2                       ;
wire  [6:0]  ExLdSt_command_2              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_2     ;
wire  Compute_valid_2                      ;
wire  [24:0]  Compute_command_2            ;
wire  ExLdSt_valid_3                       ;
wire  [6:0]  ExLdSt_command_3              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_3     ;
wire  Compute_valid_3                      ;
wire  [24:0]  Compute_command_3            ;
wire  ExLdSt_valid_4                       ;
wire  [6:0]  ExLdSt_command_4              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_4     ;
wire  Compute_valid_4                      ;
wire  [24:0]  Compute_command_4            ;
wire  ExLdSt_valid_5                       ;
wire  [6:0]  ExLdSt_command_5              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_5     ;
wire  Compute_valid_5                      ;
wire  [24:0]  Compute_command_5            ;
wire  ExLdSt_valid_6                       ;
wire  [6:0]  ExLdSt_command_6              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_6     ;
wire  Compute_valid_6                      ;
wire  [24:0]  Compute_command_6            ;
wire  ExLdSt_valid_7                       ;
wire  [6:0]  ExLdSt_command_7              ;
wire  [`Col_num-1:0]  ExLdSt_wr_data_7     ;
wire  Compute_valid_7                      ;
wire  [24:0]  Compute_command_7            ;

initial $readmemh ("./instruction.data", u_Master_controller.instr_table);

CPU_tb  u_CPU_tb (
    .CPU_instruction_irq                        ( CPU_instruction_irq                         ),

    .clk                                        ( clk                                         ),
    .rst_n                                      ( rst_n                                       ),
    .CPU_instruction_valid                      ( CPU_instruction_valid                       ),
    .CPU_instruction_addr                       ( CPU_instruction_addr                        ),
    .CPU_instruction_data                       ( CPU_instruction_data                        )
);

DRAM_tb  u_DRAM_tb (
    .clk                     ( clk                               ),
    .DRAM_valid              ( DRAM_valid                        ),
    .DRAM_wr_en              ( DRAM_wr_en                        ),
    .DRAM_addr               ( DRAM_addr     [`ddr_addr_len-1:0] ),
    .DRAM_wr_data            ( DRAM_wr_data  [`Col_num-1:0]      ),

    .DRAM_rd_data            ( DRAM_rd_data  [`Col_num-1:0]      )
);

Master_controller  u_Master_controller (
    .clk                     ( clk                                        ),
    .rst_n                   ( rst_n                                      ),
    .CPU_instruction_valid   ( CPU_instruction_valid                      ),
    .CPU_instruction_addr    ( CPU_instruction_addr   [`instr_num_bit:0]  ),
    .CPU_instruction_data    ( CPU_instruction_data   [31:0]              ),
    .DRAM_rd_data            ( DRAM_rd_data           [`Col_num-1:0]      ),
    .ExLdSt_rd_data_0        ( ExLdSt_rd_data_0       [`Col_num-1:0]      ),
    .Compute_ready_0         ( Compute_ready_0                            ),
    .ExLdSt_rd_data_1        ( ExLdSt_rd_data_1       [`Col_num-1:0]      ),
    .Compute_ready_1         ( Compute_ready_1                            ),
    .ExLdSt_rd_data_2        ( ExLdSt_rd_data_2       [`Col_num-1:0]      ),
    .Compute_ready_2         ( Compute_ready_2                            ),
    .ExLdSt_rd_data_3        ( ExLdSt_rd_data_3       [`Col_num-1:0]      ),
    .Compute_ready_3         ( Compute_ready_3                            ),
    .ExLdSt_rd_data_4        ( ExLdSt_rd_data_4       [`Col_num-1:0]      ),
    .Compute_ready_4         ( Compute_ready_4                            ),
    .ExLdSt_rd_data_5        ( ExLdSt_rd_data_5       [`Col_num-1:0]      ),
    .Compute_ready_5         ( Compute_ready_5                            ),
    .ExLdSt_rd_data_6        ( ExLdSt_rd_data_6       [`Col_num-1:0]      ),
    .Compute_ready_6         ( Compute_ready_6                            ),
    .ExLdSt_rd_data_7        ( ExLdSt_rd_data_7       [`Col_num-1:0]      ),
    .Compute_ready_7         ( Compute_ready_7                            ),

    .CPU_instruction_irq     ( CPU_instruction_irq                        ),
    .DRAM_valid              ( DRAM_valid                                 ),
    .DRAM_wr_en              ( DRAM_wr_en                                 ),
    .DRAM_addr               ( DRAM_addr              [`ddr_addr_len-1:0] ),
    .DRAM_wr_data            ( DRAM_wr_data           [`Col_num-1:0]      ),
    .ExLdSt_valid_0          ( ExLdSt_valid_0                             ),
    .ExLdSt_command_0        ( ExLdSt_command_0       [6:0]               ),
    .ExLdSt_wr_data_0        ( ExLdSt_wr_data_0       [`Col_num-1:0]      ),
    .Compute_valid_0         ( Compute_valid_0                            ),
    .Compute_command_0       ( Compute_command_0      [24:0]              ),
    .ExLdSt_valid_1          ( ExLdSt_valid_1                             ),
    .ExLdSt_command_1        ( ExLdSt_command_1       [6:0]               ),
    .ExLdSt_wr_data_1        ( ExLdSt_wr_data_1       [`Col_num-1:0]      ),
    .Compute_valid_1         ( Compute_valid_1                            ),
    .Compute_command_1       ( Compute_command_1      [24:0]              ),
    .ExLdSt_valid_2          ( ExLdSt_valid_2                             ),
    .ExLdSt_command_2        ( ExLdSt_command_2       [6:0]               ),
    .ExLdSt_wr_data_2        ( ExLdSt_wr_data_2       [`Col_num-1:0]      ),
    .Compute_valid_2         ( Compute_valid_2                            ),
    .Compute_command_2       ( Compute_command_2      [24:0]              ),
    .ExLdSt_valid_3          ( ExLdSt_valid_3                             ),
    .ExLdSt_command_3        ( ExLdSt_command_3       [6:0]               ),
    .ExLdSt_wr_data_3        ( ExLdSt_wr_data_3       [`Col_num-1:0]      ),
    .Compute_valid_3         ( Compute_valid_3                            ),
    .Compute_command_3       ( Compute_command_3      [24:0]              ),
    .ExLdSt_valid_4          ( ExLdSt_valid_4                             ),
    .ExLdSt_command_4        ( ExLdSt_command_4       [6:0]               ),
    .ExLdSt_wr_data_4        ( ExLdSt_wr_data_4       [`Col_num-1:0]      ),
    .Compute_valid_4         ( Compute_valid_4                            ),
    .Compute_command_4       ( Compute_command_4      [24:0]              ),
    .ExLdSt_valid_5          ( ExLdSt_valid_5                             ),
    .ExLdSt_command_5        ( ExLdSt_command_5       [6:0]               ),
    .ExLdSt_wr_data_5        ( ExLdSt_wr_data_5       [`Col_num-1:0]      ),
    .Compute_valid_5         ( Compute_valid_5                            ),
    .Compute_command_5       ( Compute_command_5      [24:0]              ),
    .ExLdSt_valid_6          ( ExLdSt_valid_6                             ),
    .ExLdSt_command_6        ( ExLdSt_command_6       [6:0]               ),
    .ExLdSt_wr_data_6        ( ExLdSt_wr_data_6       [`Col_num-1:0]      ),
    .Compute_valid_6         ( Compute_valid_6                            ),
    .Compute_command_6       ( Compute_command_6      [24:0]              ),
    .ExLdSt_valid_7          ( ExLdSt_valid_7                             ),
    .ExLdSt_command_7        ( ExLdSt_command_7       [6:0]               ),
    .ExLdSt_wr_data_7        ( ExLdSt_wr_data_7       [`Col_num-1:0]      ),
    .Compute_valid_7         ( Compute_valid_7                            ),
    .Compute_command_7       ( Compute_command_7      [24:0]              )
);

// wire  [`Row_num-1:0]         RWL_CH1_0          ;
// wire  [`Row_num-1:0]         RWL_CH2_0          ;
// wire  [`Row_num-1:0]         RWL_CH3_0          ;
// wire  [`Row_num-1:0]         WWL_CH1_0          ;
// wire  [`Row_num-1:0]         WWL_CH2_0          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_0          ;
// wire  [`Col_num-1:0]        RBL_ExCH_0          ;
// wire  [`Col_num-1:0]        WBL_ExCH_0          ;
// wire                      AND_enable_0          ;
// wire                      XOR_enable_0          ;
// wire                      MUL_enable_0          ;
// wire                     Booth_Sel_H_0          ;
// wire                     Booth_Sel_L_0          ;
// wire                       Booth_wen_0          ;
// wire                        TWO_data_0          ;
// wire                        NEG_data_0          ;
// wire                       ZERO_data_0          ;
// wire                           Shift_0          ;
// wire                          NShift_0          ;
// wire                     Special_Add_0          ;
// Macro_controller  u_Macro_controller_0 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_0                ),
//     .ExLdSt_command          (  ExLdSt_command_0 [6:0]          ),
//     .Compute_valid           (   Compute_valid_0                ),
//     .Compute_command         ( Compute_command_0 [24:0]         ),
//     .Compute_ready           (   Compute_ready_0                ),
//     .RWL_CH1                 (         RWL_CH1_0 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_0 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_0 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_0 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_0 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_0 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_0 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_0 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_0 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_0 [`Col_num-1:0] ),
//     .F_out                   (           F_out_0                ),
//     .AND_enable              (      AND_enable_0                ),
//     .XOR_enable              (      XOR_enable_0                ),
//     .MUL_enable              (      MUL_enable_0                ),
//     .Booth_Sel_H             (     Booth_Sel_H_0                ),
//     .Booth_Sel_L             (     Booth_Sel_L_0                ),
//     .Booth_wen               (       Booth_wen_0                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_0                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_0                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_0                ),//force ZERO=1/0
//     .Shift                   (           Shift_0                ),
//     .NShift                  (          NShift_0                ),
//     .Special_Add             (     Special_Add_0                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_1          ;
// wire  [`Row_num-1:0]         RWL_CH2_1          ;
// wire  [`Row_num-1:0]         RWL_CH3_1          ;
// wire  [`Row_num-1:0]         WWL_CH1_1          ;
// wire  [`Row_num-1:0]         WWL_CH2_1          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_1          ;
// wire  [`Col_num-1:0]        RBL_ExCH_1          ;
// wire  [`Col_num-1:0]        WBL_ExCH_1          ;
// wire                      AND_enable_1          ;
// wire                      XOR_enable_1          ;
// wire                      MUL_enable_1          ;
// wire                     Booth_Sel_H_1          ;
// wire                     Booth_Sel_L_1          ;
// wire                       Booth_wen_1          ;
// wire                        TWO_data_1          ;
// wire                        NEG_data_1          ;
// wire                       ZERO_data_1          ;
// wire                           Shift_1          ;
// wire                          NShift_1          ;
// wire                     Special_Add_1          ;
// Macro_controller  u_Macro_controller_1 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_1                ),
//     .ExLdSt_command          (  ExLdSt_command_1 [6:0]          ),
//     .Compute_valid           (   Compute_valid_1                ),
//     .Compute_command         ( Compute_command_1 [24:0]         ),
//     .Compute_ready           (   Compute_ready_1                ),
//     .RWL_CH1                 (         RWL_CH1_1 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_1 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_1 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_1 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_1 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_1 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_1 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_1 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_1 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_1 [`Col_num-1:0] ),
//     .F_out                   (           F_out_1                ),
//     .AND_enable              (      AND_enable_1                ),
//     .XOR_enable              (      XOR_enable_1                ),
//     .MUL_enable              (      MUL_enable_1                ),
//     .Booth_Sel_H             (     Booth_Sel_H_1                ),
//     .Booth_Sel_L             (     Booth_Sel_L_1                ),
//     .Booth_wen               (       Booth_wen_1                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_1                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_1                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_1                ),//force ZERO=1/0
//     .Shift                   (           Shift_1                ),
//     .NShift                  (          NShift_1                ),
//     .Special_Add             (     Special_Add_1                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_2          ;
// wire  [`Row_num-1:0]         RWL_CH2_2          ;
// wire  [`Row_num-1:0]         RWL_CH3_2          ;
// wire  [`Row_num-1:0]         WWL_CH1_2          ;
// wire  [`Row_num-1:0]         WWL_CH2_2          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_2          ;
// wire  [`Col_num-1:0]        RBL_ExCH_2          ;
// wire  [`Col_num-1:0]        WBL_ExCH_2          ;
// wire                      AND_enable_2          ;
// wire                      XOR_enable_2          ;
// wire                      MUL_enable_2          ;
// wire                     Booth_Sel_H_2          ;
// wire                     Booth_Sel_L_2          ;
// wire                       Booth_wen_2          ;
// wire                        TWO_data_2          ;
// wire                        NEG_data_2          ;
// wire                       ZERO_data_2          ;
// wire                           Shift_2          ;
// wire                          NShift_2          ;
// wire                     Special_Add_2          ;
// Macro_controller  u_Macro_controller_2 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_2                ),
//     .ExLdSt_command          (  ExLdSt_command_2 [6:0]          ),
//     .Compute_valid           (   Compute_valid_2                ),
//     .Compute_command         ( Compute_command_2 [24:0]         ),
//     .Compute_ready           (   Compute_ready_2                ),
//     .RWL_CH1                 (         RWL_CH1_2 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_2 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_2 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_2 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_2 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_2 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_2 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_2 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_2 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_2 [`Col_num-1:0] ),
//     .F_out                   (           F_out_2                ),
//     .AND_enable              (      AND_enable_2                ),
//     .XOR_enable              (      XOR_enable_2                ),
//     .MUL_enable              (      MUL_enable_2                ),
//     .Booth_Sel_H             (     Booth_Sel_H_2                ),
//     .Booth_Sel_L             (     Booth_Sel_L_2                ),
//     .Booth_wen               (       Booth_wen_2                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_2                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_2                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_2                ),//force ZERO=1/0
//     .Shift                   (           Shift_2                ),
//     .NShift                  (          NShift_2                ),
//     .Special_Add             (     Special_Add_2                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_3          ;
// wire  [`Row_num-1:0]         RWL_CH2_3          ;
// wire  [`Row_num-1:0]         RWL_CH3_3          ;
// wire  [`Row_num-1:0]         WWL_CH1_3          ;
// wire  [`Row_num-1:0]         WWL_CH2_3          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_3          ;
// wire  [`Col_num-1:0]        RBL_ExCH_3          ;
// wire  [`Col_num-1:0]        WBL_ExCH_3          ;
// wire                      AND_enable_3          ;
// wire                      XOR_enable_3          ;
// wire                      MUL_enable_3          ;
// wire                     Booth_Sel_H_3          ;
// wire                     Booth_Sel_L_3          ;
// wire                       Booth_wen_3          ;
// wire                        TWO_data_3          ;
// wire                        NEG_data_3          ;
// wire                       ZERO_data_3          ;
// wire                           Shift_3          ;
// wire                          NShift_3          ;
// wire                     Special_Add_3          ;
// Macro_controller  u_Macro_controller_3 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_3                ),
//     .ExLdSt_command          (  ExLdSt_command_3 [6:0]          ),
//     .Compute_valid           (   Compute_valid_3                ),
//     .Compute_command         ( Compute_command_3 [24:0]         ),
//     .Compute_ready           (   Compute_ready_3                ),
//     .RWL_CH1                 (         RWL_CH1_3 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_3 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_3 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_3 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_3 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_3 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_3 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_3 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_3 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_3 [`Col_num-1:0] ),
//     .F_out                   (           F_out_3                ),
//     .AND_enable              (      AND_enable_3                ),
//     .XOR_enable              (      XOR_enable_3                ),
//     .MUL_enable              (      MUL_enable_3                ),
//     .Booth_Sel_H             (     Booth_Sel_H_3                ),
//     .Booth_Sel_L             (     Booth_Sel_L_3                ),
//     .Booth_wen               (       Booth_wen_3                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_3                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_3                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_3                ),//force ZERO=1/0
//     .Shift                   (           Shift_3                ),
//     .NShift                  (          NShift_3                ),
//     .Special_Add             (     Special_Add_3                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_4          ;
// wire  [`Row_num-1:0]         RWL_CH2_4          ;
// wire  [`Row_num-1:0]         RWL_CH3_4          ;
// wire  [`Row_num-1:0]         WWL_CH1_4          ;
// wire  [`Row_num-1:0]         WWL_CH2_4          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_4          ;
// wire  [`Col_num-1:0]        RBL_ExCH_4          ;
// wire  [`Col_num-1:0]        WBL_ExCH_4          ;
// wire                      AND_enable_4          ;
// wire                      XOR_enable_4          ;
// wire                      MUL_enable_4          ;
// wire                     Booth_Sel_H_4          ;
// wire                     Booth_Sel_L_4          ;
// wire                       Booth_wen_4          ;
// wire                        TWO_data_4          ;
// wire                        NEG_data_4          ;
// wire                       ZERO_data_4          ;
// wire                           Shift_4          ;
// wire                          NShift_4          ;
// wire                     Special_Add_4          ;
// Macro_controller  u_Macro_controller_4 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_4                ),
//     .ExLdSt_command          (  ExLdSt_command_4 [6:0]          ),
//     .Compute_valid           (   Compute_valid_4                ),
//     .Compute_command         ( Compute_command_4 [24:0]         ),
//     .Compute_ready           (   Compute_ready_4                ),
//     .RWL_CH1                 (         RWL_CH1_4 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_4 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_4 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_4 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_4 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_4 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_4 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_4 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_4 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_4 [`Col_num-1:0] ),
//     .F_out                   (           F_out_4                ),
//     .AND_enable              (      AND_enable_4                ),
//     .XOR_enable              (      XOR_enable_4                ),
//     .MUL_enable              (      MUL_enable_4                ),
//     .Booth_Sel_H             (     Booth_Sel_H_4                ),
//     .Booth_Sel_L             (     Booth_Sel_L_4                ),
//     .Booth_wen               (       Booth_wen_4                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_4                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_4                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_4                ),//force ZERO=1/0
//     .Shift                   (           Shift_4                ),
//     .NShift                  (          NShift_4                ),
//     .Special_Add             (     Special_Add_4                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_5          ;
// wire  [`Row_num-1:0]         RWL_CH2_5          ;
// wire  [`Row_num-1:0]         RWL_CH3_5          ;
// wire  [`Row_num-1:0]         WWL_CH1_5          ;
// wire  [`Row_num-1:0]         WWL_CH2_5          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_5          ;
// wire  [`Col_num-1:0]        RBL_ExCH_5          ;
// wire  [`Col_num-1:0]        WBL_ExCH_5          ;
// wire                      AND_enable_5          ;
// wire                      XOR_enable_5          ;
// wire                      MUL_enable_5          ;
// wire                     Booth_Sel_H_5          ;
// wire                     Booth_Sel_L_5          ;
// wire                       Booth_wen_5          ;
// wire                        TWO_data_5          ;
// wire                        NEG_data_5          ;
// wire                       ZERO_data_5          ;
// wire                           Shift_5          ;
// wire                          NShift_5          ;
// wire                     Special_Add_5          ;
// Macro_controller  u_Macro_controller_5 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_5                ),
//     .ExLdSt_command          (  ExLdSt_command_5 [6:0]          ),
//     .Compute_valid           (   Compute_valid_5                ),
//     .Compute_command         ( Compute_command_5 [24:0]         ),
//     .Compute_ready           (   Compute_ready_5                ),
//     .RWL_CH1                 (         RWL_CH1_5 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_5 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_5 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_5 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_5 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_5 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_5 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_5 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_5 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_5 [`Col_num-1:0] ),
//     .F_out                   (           F_out_5                ),
//     .AND_enable              (      AND_enable_5                ),
//     .XOR_enable              (      XOR_enable_5                ),
//     .MUL_enable              (      MUL_enable_5                ),
//     .Booth_Sel_H             (     Booth_Sel_H_5                ),
//     .Booth_Sel_L             (     Booth_Sel_L_5                ),
//     .Booth_wen               (       Booth_wen_5                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_5                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_5                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_5                ),//force ZERO=1/0
//     .Shift                   (           Shift_5                ),
//     .NShift                  (          NShift_5                ),
//     .Special_Add             (     Special_Add_5                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_6          ;
// wire  [`Row_num-1:0]         RWL_CH2_6          ;
// wire  [`Row_num-1:0]         RWL_CH3_6          ;
// wire  [`Row_num-1:0]         WWL_CH1_6          ;
// wire  [`Row_num-1:0]         WWL_CH2_6          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_6          ;
// wire  [`Col_num-1:0]        RBL_ExCH_6          ;
// wire  [`Col_num-1:0]        WBL_ExCH_6          ;
// wire                      AND_enable_6          ;
// wire                      XOR_enable_6          ;
// wire                      MUL_enable_6          ;
// wire                     Booth_Sel_H_6          ;
// wire                     Booth_Sel_L_6          ;
// wire                       Booth_wen_6          ;
// wire                        TWO_data_6          ;
// wire                        NEG_data_6          ;
// wire                       ZERO_data_6          ;
// wire                           Shift_6          ;
// wire                          NShift_6          ;
// wire                     Special_Add_6          ;
// Macro_controller  u_Macro_controller_6 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_6                ),
//     .ExLdSt_command          (  ExLdSt_command_6 [6:0]          ),
//     .Compute_valid           (   Compute_valid_6                ),
//     .Compute_command         ( Compute_command_6 [24:0]         ),
//     .Compute_ready           (   Compute_ready_6                ),
//     .RWL_CH1                 (         RWL_CH1_6 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_6 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_6 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_6 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_6 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_6 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_6 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_6 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_6 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_6 [`Col_num-1:0] ),
//     .F_out                   (           F_out_6                ),
//     .AND_enable              (      AND_enable_6                ),
//     .XOR_enable              (      XOR_enable_6                ),
//     .MUL_enable              (      MUL_enable_6                ),
//     .Booth_Sel_H             (     Booth_Sel_H_6                ),
//     .Booth_Sel_L             (     Booth_Sel_L_6                ),
//     .Booth_wen               (       Booth_wen_6                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_6                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_6                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_6                ),//force ZERO=1/0
//     .Shift                   (           Shift_6                ),
//     .NShift                  (          NShift_6                ),
//     .Special_Add             (     Special_Add_6                )
// ); 

// wire  [`Row_num-1:0]         RWL_CH1_7          ;
// wire  [`Row_num-1:0]         RWL_CH2_7          ;
// wire  [`Row_num-1:0]         RWL_CH3_7          ;
// wire  [`Row_num-1:0]         WWL_CH1_7          ;
// wire  [`Row_num-1:0]         WWL_CH2_7          ;
// wire  [`Row_num-1:0]       RWWL_ExCH_7          ;
// wire  [`Col_num-1:0]        RBL_ExCH_7          ;
// wire  [`Col_num-1:0]        WBL_ExCH_7          ;
// wire                      AND_enable_7          ;
// wire                      XOR_enable_7          ;
// wire                      MUL_enable_7          ;
// wire                     Booth_Sel_H_7          ;
// wire                     Booth_Sel_L_7          ;
// wire                       Booth_wen_7          ;
// wire                        TWO_data_7          ;
// wire                        NEG_data_7          ;
// wire                       ZERO_data_7          ;
// wire                           Shift_7          ;
// wire                          NShift_7          ;
// wire                     Special_Add_7          ;
// Macro_controller  u_Macro_controller_7 (
//     .clk                     ( clk                              ),
//     .F_in                    ( F_in                             ),
//     .ExLdSt_valid            (    ExLdSt_valid_7                ),
//     .ExLdSt_command          (  ExLdSt_command_7 [6:0]          ),
//     .Compute_valid           (   Compute_valid_7                ),
//     .Compute_command         ( Compute_command_7 [24:0]         ),
//     .Compute_ready           (   Compute_ready_7                ),
//     .RWL_CH1                 (         RWL_CH1_7 [`Row_num-1:0] ),
//     .RWL_CH2                 (         RWL_CH2_7 [`Row_num-1:0] ),
//     .RWL_CH3                 (         RWL_CH3_7 [`Row_num-1:0] ),
//     .WWL_CH1                 (         WWL_CH1_7 [`Row_num-1:0] ),
//     .WWL_CH2                 (         WWL_CH2_7 [`Row_num-1:0] ),
//     .RWWL_ExCH               (       RWWL_ExCH_7 [`Row_num-1:0] ),
//     .ExLdSt_wr_data          (  ExLdSt_wr_data_7 [`Col_num-1:0] ),
//     .ExLdSt_rd_data          (  ExLdSt_rd_data_7 [`Col_num-1:0] ),
//     .RBL_ExCH                (        RBL_ExCH_7 [`Col_num-1:0] ),
//     .WBL_ExCH                (        WBL_ExCH_7 [`Col_num-1:0] ),
//     .F_out                   (           F_out_7                ),
//     .AND_enable              (      AND_enable_7                ),
//     .XOR_enable              (      XOR_enable_7                ),
//     .MUL_enable              (      MUL_enable_7                ),
//     .Booth_Sel_H             (     Booth_Sel_H_7                ),
//     .Booth_Sel_L             (     Booth_Sel_L_7                ),
//     .Booth_wen               (       Booth_wen_7                ),//write TWO/NEG forcely
//     .TWO_data                (        TWO_data_7                ),//force TWO=1/0
//     .NEG_data                (        NEG_data_7                ),//force NEG=1/0
//     .ZERO_data               (       ZERO_data_7                ),//force ZERO=1/0
//     .Shift                   (           Shift_7                ),
//     .NShift                  (          NShift_7                ),
//     .Special_Add             (     Special_Add_7                )
// ); 

endmodule
