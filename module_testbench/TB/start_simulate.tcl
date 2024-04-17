vlib  work
vmap  work ./work

# vlog -O5 -vopt "../RTL/top_tb.v" -work work
# vlog -O5 -vopt "../RTL/MUL_controller.v" -work work
# vlog -O5 -vopt "../RTL/MUL_controller_tb.v" -work work

vlog -O5 -vopt "../RTL/Master_controller.v" -work work

vlog -O5 -vopt "../RTL/Master_controller_top_tb.sv" -work work
vlog -O5 -vopt "../RTL/CPU_tb.sv" -work work
vlog -O5 -vopt "../RTL/DRAM_tb.sv" -work work

vsim -voptargs="+acc" -sva -nowlflock -wlf "vsim.wlf" -L work top_tb

log -r /*

do master_wave.do

run 100ns