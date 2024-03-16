`include "defines.v"

module top_tb;   

// MUL_contorller_tb Outputs
wire  clk                                  ;
wire  F_in                                 ;
wire  ExLdSt_valid                         ;
wire  [6:0]  ExLdSt_command                ;
wire  Compute_valid                        ;
wire  [24:0]  Compute_command              ;

// MUL_contorller_tb Bidirs
wire  [`Row_num-1:0]  ExLdSt_data          ;

// MUL_contorller Outputs
wire  Compute_ready                        ;
wire  [`Col_num-1:0]  RWL_CH1              ;
wire  [`Col_num-1:0]  RWL_CH2              ;
wire  [`Col_num-1:0]  RWL_CH3              ;
wire  [`Col_num-1:0]  WWL_CH1              ;
wire  [`Col_num-1:0]  WWL_CH2              ;
wire  [`Col_num-1:0]  RWWL_ExCH            ;
wire  RWWL_ExCH_wen                        ;
wire  RWWL_ExCH_ren                        ;
wire  F_out                                ;

// MUL_contorller Bidirs
wire  [`Row_num-1:0]  RWBL_ExCH            ;

MUL_controller  u_MUL_controller (
    .clk                     ( clk                             ),
    .F_in                    ( F_in                            ),
    .ExLdSt_valid            ( ExLdSt_valid                    ),
    .ExLdSt_command          ( ExLdSt_command   [6:0]          ),
    .Compute_valid           ( Compute_valid                   ),
    .Compute_command         ( Compute_command  [24:0]         ),

    .Compute_ready           ( Compute_ready                   ),
    .RWL_CH1                 ( RWL_CH1          [`Col_num-1:0] ),
    .RWL_CH2                 ( RWL_CH2          [`Col_num-1:0] ),
    .RWL_CH3                 ( RWL_CH3          [`Col_num-1:0] ),
    .WWL_CH1                 ( WWL_CH1          [`Col_num-1:0] ),
    .WWL_CH2                 ( WWL_CH2          [`Col_num-1:0] ),
    .RWWL_ExCH               ( RWWL_ExCH        [`Col_num-1:0] ),
    .RWWL_ExCH_wen           ( RWWL_ExCH_wen                   ),
    .RWWL_ExCH_ren           ( RWWL_ExCH_ren                   ),
    .F_out                   ( F_out                           ),

    .ExLdSt_data             ( ExLdSt_data      [`Row_num-1:0] ),
    .RWBL_ExCH               ( RWBL_ExCH        [`Row_num-1:0] )
);
MUL_controller_tb  u_MUL_controller_tb (
    .clk                     ( clk                             ),
    .F_in                    ( F_in                            ),
    .ExLdSt_valid            ( ExLdSt_valid                    ),
    .ExLdSt_command          ( ExLdSt_command   [6:0]          ),
    .Compute_valid           ( Compute_valid                   ),
    .Compute_ready           ( Compute_ready                   ),
    .Compute_command         ( Compute_command  [24:0]         ),

    .ExLdSt_data             ( ExLdSt_data      [`Row_num-1:0] )
);

endmodule
