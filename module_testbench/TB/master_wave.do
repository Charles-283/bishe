onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst_n
add wave -noupdate -expand -group CPU /top_tb/u_Master_controller/CPU_instruction_valid
add wave -noupdate -expand -group CPU /top_tb/u_Master_controller/CPU_instruction_irq
add wave -noupdate -expand -group CPU /top_tb/u_Master_controller/CPU_instruction_addr
add wave -noupdate -expand -group CPU /top_tb/u_Master_controller/CPU_instruction_data
add wave -noupdate -expand -group DRAM /top_tb/u_Master_controller/DRAM_valid
add wave -noupdate -expand -group DRAM /top_tb/u_Master_controller/DRAM_wr_en
add wave -noupdate -expand -group DRAM /top_tb/u_Master_controller/DRAM_addr
add wave -noupdate -expand -group DRAM /top_tb/u_Master_controller/DRAM_rd_data
add wave -noupdate -expand -group DRAM /top_tb/u_Master_controller/DRAM_wr_data
add wave -noupdate -expand -group Decoder /top_tb/u_Master_controller/instr_valid
add wave -noupdate -expand -group Decoder /top_tb/u_Master_controller/instr_addr
add wave -noupdate -expand -group Decoder /top_tb/u_Master_controller/instruction
add wave -noupdate -expand -group Decoder /top_tb/u_Master_controller/status_register
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/LRT_instr_valid
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_stk_cnt_valid
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_ddr_addr_valid
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_stk_cnt_addr
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_ddr_addr_addr
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_stack
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_counter
add wave -noupdate -expand -group Decoder -expand -group LRT_decode /top_tb/u_Master_controller/Ld_ddr_addr
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/Macro_instr_valid
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/stk_cnt_valid
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/stk_cnt_addr
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/addr_incr_valid
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/addr_incr
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/pipeline_en
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/pipeline_latency
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/ExLdSt_ddr_addr
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/ExLdSt_macro_selmode
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/ExLdSt_macro_sel
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/ExLdSt_command
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/Compute_macro_sel
add wave -noupdate -expand -group Decoder -expand -group Macro_decode /top_tb/u_Master_controller/Compute_command
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/counter_all_zero
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/counting_done
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/counting
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/ExLdSt_pipe_valid
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/Compute_pipe_valid
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/pipeline_counter
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/pipeline_clk
add wave -noupdate -expand -group Pipeline /top_tb/u_Master_controller/pipeline_en
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/ExLdSt_valid_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/ExLdSt_command_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/ExLdSt_wr_data_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/ExLdSt_rd_data_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/Compute_valid_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/Compute_ready_0
add wave -noupdate -group Macro -group Macro0 /top_tb/u_Master_controller/Compute_command_0
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/ExLdSt_valid_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/ExLdSt_command_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/ExLdSt_wr_data_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/ExLdSt_rd_data_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/Compute_valid_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/Compute_ready_1
add wave -noupdate -group Macro -group Macro1 /top_tb/u_Master_controller/Compute_command_1
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/ExLdSt_valid_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/ExLdSt_command_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/ExLdSt_wr_data_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/ExLdSt_rd_data_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/Compute_valid_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/Compute_ready_2
add wave -noupdate -group Macro -group Macro2 /top_tb/u_Master_controller/Compute_command_2
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/ExLdSt_valid_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/ExLdSt_command_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/ExLdSt_wr_data_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/ExLdSt_rd_data_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/Compute_valid_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/Compute_ready_3
add wave -noupdate -group Macro -group Macro3 /top_tb/u_Master_controller/Compute_command_3
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/ExLdSt_valid_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/ExLdSt_command_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/ExLdSt_wr_data_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/ExLdSt_rd_data_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/Compute_valid_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/Compute_ready_4
add wave -noupdate -group Macro -group Macro4 /top_tb/u_Master_controller/Compute_command_4
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/ExLdSt_valid_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/ExLdSt_command_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/ExLdSt_wr_data_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/ExLdSt_rd_data_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/Compute_valid_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/Compute_ready_5
add wave -noupdate -group Macro -group Macro5 /top_tb/u_Master_controller/Compute_command_5
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/ExLdSt_valid_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/ExLdSt_command_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/ExLdSt_wr_data_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/ExLdSt_rd_data_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/Compute_valid_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/Compute_ready_6
add wave -noupdate -group Macro -group Macro6 /top_tb/u_Master_controller/Compute_command_6
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/ExLdSt_valid_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/ExLdSt_command_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/ExLdSt_wr_data_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/ExLdSt_rd_data_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/Compute_valid_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/Compute_ready_7
add wave -noupdate -group Macro -group Macro7 /top_tb/u_Master_controller/Compute_command_7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {100500 ps}
