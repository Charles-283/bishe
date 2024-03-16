onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/F_in
add wave -noupdate -expand -group Command_signal /top_tb/ExLdSt_valid
add wave -noupdate -expand -group Command_signal /top_tb/ExLdSt_command
add wave -noupdate -expand -group Command_signal /top_tb/ExLdSt_data
add wave -noupdate -expand -group Command_signal /top_tb/Compute_valid
add wave -noupdate -expand -group Command_signal /top_tb/Compute_ready
add wave -noupdate -expand -group Command_signal /top_tb/Compute_command
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH1_en
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH2_en
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH3_en
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/WWL_CH1_en
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/WWL_CH2_en
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH1_addr
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH2_addr
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/RWL_CH3_addr
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/WWL_CH1_addr
add wave -noupdate -expand -group RW_addr /top_tb/u_MUL_controller/WWL_CH2_addr
add wave -noupdate -expand -group RW_addr -expand -group RWWL_ExCH /top_tb/RWWL_ExCH_wen
add wave -noupdate -expand -group RW_addr -expand -group RWWL_ExCH /top_tb/RWWL_ExCH_ren
add wave -noupdate -expand -group RW_addr -expand -group RWWL_ExCH /top_tb/u_MUL_controller/RWWL_ExCH_addr
add wave -noupdate -expand -group RW_addr -expand -group RWWL_ExCH /top_tb/RWBL_ExCH
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/AND_enable
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/XOR_enable
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/MUL_enable
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/Booth_Sel_H
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/Booth_Sel_L
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/Booth_wen
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/TWO_data
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/NEG_data
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/Shift
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/NShift
add wave -noupdate -expand -group Control_signal /top_tb/u_MUL_controller/Special_Add
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28100 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 72
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
WaveRestoreZoom {0 ps} {110200 ps}
