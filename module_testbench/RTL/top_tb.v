`timescale 1ns/100ps

// signal length
`define Row_num_bit         6
`define Row_num             (1 << `Row_num_bit)
`define Col_num             16

module top_tb;   

// MUL_contorller_tb Outputs
wire  clk                                  ;
wire  F_in                                 ;
wire  ExLdSt_valid                         ;
wire  [6:0]  ExLdSt_command                ;
wire  Compute_valid                        ;
wire  [24:0]  Compute_command              ;

// MUL_contorller_tb Bidirs
wire  [`Col_num-1:0]  ExLdSt_data          ;

// MUL_contorller Outputs
wire  Compute_ready                        ;
wire  [`Row_num-1:0]  RWL_CH1              ;
wire  [`Row_num-1:0]  RWL_CH2              ;
wire  [`Row_num-1:0]  RWL_CH3              ;
wire  [`Row_num-1:0]  WWL_CH1              ;
wire  [`Row_num-1:0]  WWL_CH2              ;
wire  [`Row_num-1:0]  RWWL_ExCH            ;
wire  F_out                                ;              
wire  AND_enable                           ;
wire  XOR_enable                           ;
wire  MUL_enable                           ;
wire  Booth_Sel_H                          ;
wire  Booth_Sel_L                          ;
wire  Booth_wen                            ;
wire  TWO_data                             ;
wire  NEG_data                             ;
wire  ZERO_data                            ;
wire  Shift                                ;
wire  NShift                               ;
wire  Special_Add                          ;


// MUL_contorller Bidirs
wire  [`Col_num-1:0]  RBL_ExCH             ;
wire  [`Col_num-1:0]  WBL_ExCH             ;

MUL_controller  u_MUL_controller (
    .clk                     ( clk                             ),
    .F_in                    ( F_in                            ),
    .ExLdSt_valid            ( ExLdSt_valid                    ),
    .ExLdSt_command          ( ExLdSt_command   [6:0]          ),
    .Compute_valid           ( Compute_valid                   ),
    .Compute_command         ( Compute_command  [24:0]         ),

    .Compute_ready           ( Compute_ready                   ),
    .RWL_CH1                 ( RWL_CH1          [`Row_num-1:0] ),
    .RWL_CH2                 ( RWL_CH2          [`Row_num-1:0] ),
    .RWL_CH3                 ( RWL_CH3          [`Row_num-1:0] ),
    .WWL_CH1                 ( WWL_CH1          [`Row_num-1:0] ),
    .WWL_CH2                 ( WWL_CH2          [`Row_num-1:0] ),
    .RWWL_ExCH               ( RWWL_ExCH        [`Row_num-1:0] ),

    .ExLdSt_data             ( ExLdSt_data      [`Col_num-1:0] ),
    .RBL_ExCH                ( RBL_ExCH         [`Col_num-1:0] ),
    .WBL_ExCH                ( WBL_ExCH         [`Col_num-1:0] ),

    .F_out                   (F_out                            ),
    .AND_enable              (AND_enable                       ),
    .XOR_enable              (XOR_enable                       ),
    .MUL_enable              (MUL_enable                       ),
    .Booth_Sel_H             (Booth_Sel_H                      ),
    .Booth_Sel_L             (Booth_Sel_L                      ),
    .Booth_wen               (Booth_wen                        ),//write TWO/NEG forcely
    .TWO_data                (TWO_data                         ),//force TWO=1/0
    .NEG_data                (NEG_data                         ),//force NEG=1/0
    .ZERO_data               (ZERO_data                        ),//force ZERO=1/0
    .Shift                   (Shift                            ),
    .NShift                  (NShift                           ),
    .Special_Add             (Special_Add                      )
);              
MUL_controller_tb  u_MUL_controller_tb (
    .clk                     ( clk                             ),
    .F_in                    ( F_in                            ),
    .ExLdSt_valid            ( ExLdSt_valid                    ),
    .ExLdSt_command          ( ExLdSt_command   [6:0]          ),
    .Compute_valid           ( Compute_valid                   ),
    .Compute_ready           ( Compute_ready                   ),
    .Compute_command         ( Compute_command  [24:0]         ),

    .ExLdSt_data             ( ExLdSt_data      [`Col_num-1:0] )
);

endmodule
