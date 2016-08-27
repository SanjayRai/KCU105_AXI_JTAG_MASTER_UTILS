# Created : 10:42:12, Mon Aug 1, 2016 : Sanjay Rai

source ../device_type.tcl

create_project project_X project_X -part [DEVICE_TYPE]
set_property board_part xilinx.com:kcu105:part0:1.1 [current_project]


add_files -norecurse {
../IP/KCU105_AXI_JTAG_MASTER/KCU105_AXI_JTAG_MASTER.bd
../src/KCU105_AXI_JTAG_MASTER_wrapper.v
}
add_files -fileset constrs_1 {
../src/xdc/KCU105_AXI_JTAG_MASTER_wrapper.xdc
}
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
if (1) {
launch_runs synth_1
wait_on_run synth_1
open_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1
}
