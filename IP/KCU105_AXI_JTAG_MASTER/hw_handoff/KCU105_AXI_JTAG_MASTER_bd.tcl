
################################################################
# This is a generated script based on design: KCU105_AXI_JTAG_MASTER
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source KCU105_AXI_JTAG_MASTER_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku040-ffva1156-2-e
   set_property BOARD_PART xilinx.com:kcu105:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name KCU105_AXI_JTAG_MASTER

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  set str_bd_folder /home/sanjayr/projects/KCU105/KCU105_AXI_JTAG_MASTER_BRAM/IP
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_msg_id "BD_TCL-110" "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_msg_id "BD_TCL-008" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_msg_id "BD_TCL-009" "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-111" "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-010" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_msg_id "BD_TCL-112" "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_msg_id "BD_TCL-113" "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_msg_id "BD_TCL-011" "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_msg_id "BD_TCL-012" "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set sysclk_125 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sysclk_125 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {125000000} \
 ] $sysclk_125

  # Create ports
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $axi_bram_ctrl_0_bram

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.use_bram_block.VALUE_SRC {DEFAULT} \
 ] $axi_bram_ctrl_0_bram

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $axi_mem_intercon

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_JITTER {124.615} \
CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
CONFIG.CLK_IN1_BOARD_INTERFACE {sysclk_125} \
CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
CONFIG.MMCM_CLKIN1_PERIOD {8.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
CONFIG.RESET_BOARD_INTERFACE {reset} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_JITTER.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_PHASE_ERROR.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.PRIM_SOURCE.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_0 ]
  set_property -dict [ list \
CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
CONFIG.C_DATA_DEPTH {4096} \
CONFIG.C_EN_STRG_QUAL {1} \
CONFIG.C_INPUT_PIPE_STAGES {4} \
CONFIG.C_MONITOR_TYPE {AXI} \
CONFIG.C_PROBE0_MU_CNT {2} \
CONFIG.C_PROBE10_MU_CNT {2} \
CONFIG.C_PROBE11_MU_CNT {2} \
CONFIG.C_PROBE12_MU_CNT {2} \
CONFIG.C_PROBE13_MU_CNT {2} \
CONFIG.C_PROBE14_MU_CNT {2} \
CONFIG.C_PROBE15_MU_CNT {2} \
CONFIG.C_PROBE16_MU_CNT {2} \
CONFIG.C_PROBE17_MU_CNT {2} \
CONFIG.C_PROBE18_MU_CNT {2} \
CONFIG.C_PROBE19_MU_CNT {2} \
CONFIG.C_PROBE1_MU_CNT {2} \
CONFIG.C_PROBE20_MU_CNT {2} \
CONFIG.C_PROBE21_MU_CNT {2} \
CONFIG.C_PROBE22_MU_CNT {2} \
CONFIG.C_PROBE23_MU_CNT {2} \
CONFIG.C_PROBE24_MU_CNT {2} \
CONFIG.C_PROBE25_MU_CNT {2} \
CONFIG.C_PROBE26_MU_CNT {2} \
CONFIG.C_PROBE27_MU_CNT {2} \
CONFIG.C_PROBE28_MU_CNT {2} \
CONFIG.C_PROBE29_MU_CNT {2} \
CONFIG.C_PROBE2_MU_CNT {2} \
CONFIG.C_PROBE30_MU_CNT {2} \
CONFIG.C_PROBE31_MU_CNT {2} \
CONFIG.C_PROBE32_MU_CNT {2} \
CONFIG.C_PROBE33_MU_CNT {2} \
CONFIG.C_PROBE34_MU_CNT {2} \
CONFIG.C_PROBE35_MU_CNT {2} \
CONFIG.C_PROBE36_MU_CNT {2} \
CONFIG.C_PROBE37_MU_CNT {2} \
CONFIG.C_PROBE38_MU_CNT {2} \
CONFIG.C_PROBE39_MU_CNT {2} \
CONFIG.C_PROBE3_MU_CNT {2} \
CONFIG.C_PROBE40_MU_CNT {2} \
CONFIG.C_PROBE41_MU_CNT {2} \
CONFIG.C_PROBE42_MU_CNT {2} \
CONFIG.C_PROBE43_MU_CNT {2} \
CONFIG.C_PROBE4_MU_CNT {2} \
CONFIG.C_PROBE5_MU_CNT {2} \
CONFIG.C_PROBE6_MU_CNT {2} \
CONFIG.C_PROBE7_MU_CNT {2} \
CONFIG.C_PROBE8_MU_CNT {2} \
CONFIG.C_PROBE9_MU_CNT {2} \
 ] $ila_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.C_MONITOR_TYPE.VALUE_SRC {DEFAULT} \
 ] $ila_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.1 jtag_axi_0 ]

  # Create instance: rst_clk_wiz_0_100M, and set properties
  set rst_clk_wiz_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_100M ]
  set_property -dict [ list \
CONFIG.RESET_BOARD_INTERFACE {reset} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_clk_wiz_0_100M

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets jtag_axi_0_M_AXI] [get_bd_intf_pins ila_0/SLOT_0_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net sysclk_125_1 [get_bd_intf_ports sysclk_125] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins ila_0/clk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins rst_clk_wiz_0_100M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_clk_wiz_0_100M/dcm_locked]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins rst_clk_wiz_0_100M/ext_reset_in] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net rst_clk_wiz_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins rst_clk_wiz_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_0_100M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_100M/peripheral_aresetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments
  create_bd_addr_seg -range 0x00002000 -offset 0x00000000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port sysclk_125 -pg 1 -y -390 -defaultsOSRD
preplace port reset -pg 1 -y -370 -defaultsOSRD
preplace inst rst_clk_wiz_0_100M -pg 1 -lvl 2 -y -350 -defaultsOSRD
preplace inst axi_bram_ctrl_0_bram -pg 1 -lvl 4 -y -70 -defaultsOSRD
preplace inst jtag_axi_0 -pg 1 -lvl 2 -y -180 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -y -140 -defaultsOSRD
preplace inst ila_0 -pg 1 -lvl 3 -y 80 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -y -250 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 3 -y -120 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 3 -y -290 -defaultsOSRD
preplace netloc clk_wiz_0_locked 1 1 1 260
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 3 1 970
preplace netloc axi_bram_ctrl_0_BRAM_PORTB 1 3 1 960
preplace netloc util_vector_logic_0_Res 1 1 1 260
preplace netloc axi_mem_intercon_M00_AXI 1 2 2 650 -360 950
preplace netloc jtag_axi_0_M_AXI 1 2 1 620
preplace netloc sysclk_125_1 1 0 1 10
preplace netloc clk_wiz_0_clk_out1 1 1 2 270 -260 630
preplace netloc rst_clk_wiz_0_100M_interconnect_aresetn 1 2 1 640
preplace netloc rst_clk_wiz_0_100M_peripheral_aresetn 1 2 1 610
preplace netloc reset_1 1 0 2 20 -370 N
levelinfo -pg 1 -10 140 440 800 1070 1180 -top -430 -bot 140
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


