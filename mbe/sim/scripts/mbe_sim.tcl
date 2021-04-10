vcom -93 -work ./work ../src/mbe/ha.vhd
vcom -93 -work ./work ../src/mbe/fa.vhd
vcom -93 -work ./work ../src/mbe/dadda.vhd
vcom -93 -work ./work ../src/mbe/pj_generator.vhd
vcom -93 -work ./work ../src/mbe/mbe.vhd

vlog -sv ../tb/top.sv
vsim top

add wave -position insertpoint sim:/top/state
add wave -position insertpoint sim:/top/in/*

run 4000 ns
