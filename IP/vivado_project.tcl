# Created : 10:42:12, Mon Aug 1, 2016 : Sanjay Rai

source ../device_type.tcl
create_project project_X project_X -part [DEVICE_TYPE] 
set_property board_part xilinx.com:kcu105:part0:1.1 [current_project]

add_files -fileset sources_1 -norecurse {
}

