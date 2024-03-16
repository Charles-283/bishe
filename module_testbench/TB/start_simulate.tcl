vlib  work
vmap  work ./work

vlog -O5 -vopt "../RTL/top_tb.v" -work work
vlog -O5 -vopt "../RTL/MUL_controller.v" -work work
vlog -O5 -vopt "../RTL/MUL_controller_tb.v" -work work
vsim  -voptargs="+acc" -L work top_tb

log -r /*

do wave.do

run 100ns