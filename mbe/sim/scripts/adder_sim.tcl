rm -r work
vlib work
vlog -sv ../tb/top.sv
vsim top

add wave -position insertpoint sim:/top/state
add wave -position insertpoint sim:/top/in/*

run 4000 ns
