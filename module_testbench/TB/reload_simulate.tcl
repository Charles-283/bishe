vlog -O5 -vopt "../RTL/top_tb.v" -work work
vlog -O5 -vopt "../RTL/MUL_controller.v" -work work
vlog -O5 -vopt "../RTL/MUL_controller_tb.v" -work work

restart

run 100ns