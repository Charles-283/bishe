# vlog -O5 -vopt -incr "../RTL/top_tb.v" -work work
# vlog -O5 -vopt -incr "../RTL/MUL_controller.v" -work work
# vlog -O5 -vopt -incr "../RTL/MUL_controller_tb.v" -work work

vlog -O5 -vopt -incr "../RTL/Master_controller.v" -work work

vlog -O5 -vopt -incr "../RTL/Master_controller_top_tb.sv" -work work
vlog -O5 -vopt -incr "../RTL/CPU_tb.sv" -work work
vlog -O5 -vopt -incr "../RTL/DRAM_tb.sv" -work work


restart

run 1us