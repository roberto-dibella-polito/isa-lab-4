# Packets
vcom -93 -work ./work ../src/common/fpnormalize_fpnormalize.vhd
vcom -93 -work ./work ../src/common/fpround_fpround.vhd
vcom -93 -work ./work ../src/common/packfp_packfp.vhd
vcom -93 -work ./work ../src/common/unpackfp_unpackfp.vhd

# MBE Multiplier
vcom -93 -work ./work ../../mbe/src/mbe/ha.vhd
vcom -93 -work ./work ../../mbe/src/mbe/fa.vhd
vcom -93 -work ./work ../../mbe/src/mbe/dadda.vhd
vcom -93 -work ./work ../../mbe/src/mbe/pj_generator.vhd
vcom -93 -work ./work ../../mbe/src/mbe/mbe.vhd

# Floating Point Multiplier
vcom -93 -work ./work ../src/multiplier/fpmul_stage1_struct.vhd
vcom -93 -work ./work ../src/multiplier/fpmul_stage2_struct_fgp_mbe.vhd
vcom -93 -work ./work ../src/multiplier/fpmul_stage3_struct.vhd
vcom -93 -work ./work ../src/multiplier/fpmul_stage4_struct.vhd
vcom -93 -work ./work ../src/multiplier/fpmul_pipeline.vhd

vlog -sv ../tb/top.sv
vsim top

add wave -position insertpoint sim:/top/state
add wave -position insertpoint sim:/top/in/*
add wave -position insertpoint  \
sim:/top/FPmul/fpmul_under_test/clk \
sim:/top/FPmul/fpmul_under_test/FP_A \
sim:/top/FPmul/fpmul_under_test/FP_B \
sim:/top/FPmul/fpmul_under_test/FP_Z

add wave -position insertpoint  \
sim:/top/FPmul/fpmul_under_test/regA_to_st1 \
sim:/top/FPmul/fpmul_under_test/I1/A_EXP \
sim:/top/FPmul/fpmul_under_test/I2/prod_to_sig \
sim:/top/FPmul/fpmul_under_test/I2/EXP_in \
sim:/top/FPmul/fpmul_under_test/I3/EXP_out_round \
sim:/top/FPmul/fpmul_under_test/I4/FP_Z \
sim:/top/FPmul/out_inter/valid \


run 80500 ns
