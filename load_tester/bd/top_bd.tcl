
################################################################
# This is a generated script based on design: top
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
set scripts_vivado_version 2019.1
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
# source top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# bram_top_wrapper, dsp_top_wrapper

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tfbg484-3
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:pcie_7x:3.3\
xilinx.com:user:pcie_axi_lite_v1_0:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xadc_wiz:3.3\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
bram_top_wrapper\
dsp_top_wrapper\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

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
  set pcie_clkin [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_clkin ]

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]


  # Create ports
  set pcie_clkreq [ create_bd_port -dir O -from 0 -to 0 pcie_clkreq ]
  set pcie_reset [ create_bd_port -dir I -type rst pcie_reset ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_mem_intercon

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]

  # Create instance: bram_top_wrapper_0, and set properties
  set block_name bram_top_wrapper
  set block_cell_name bram_top_wrapper_0
  if { [catch {set bram_top_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bram_top_wrapper_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.NUM_BRAMS {357} \
 ] $bram_top_wrapper_0

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {197.700} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {100.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.USE_DYN_RECONFIG {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wiz

  # Create instance: dsp_top_wrapper_0, and set properties
  set block_name dsp_top_wrapper
  set block_cell_name dsp_top_wrapper_0
  if { [catch {set dsp_top_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dsp_top_wrapper_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.NUM_DSPS {350} \
 ] $dsp_top_wrapper_0

  # Create instance: pcie_7x_0, and set properties
  set pcie_7x_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_7x:3.3 pcie_7x_0 ]
  set_property -dict [ list \
   CONFIG.Bar0_Scale {Megabytes} \
   CONFIG.Bar0_Size {1} \
   CONFIG.Device_ID {7024} \
   CONFIG.IntX_Generation {false} \
   CONFIG.Interface_Width {128_bit} \
   CONFIG.Legacy_Interrupt {NONE} \
   CONFIG.Link_Speed {5.0_GT/s} \
   CONFIG.MSI_64b {false} \
   CONFIG.Max_Payload_Size {512_bytes} \
   CONFIG.Maximum_Link_Width {X4} \
   CONFIG.PCIe_Blk_Locn {X0Y0} \
   CONFIG.PCIe_Debug_Ports {false} \
   CONFIG.Ref_Clk_Freq {100_MHz} \
   CONFIG.Trans_Buf_Pipeline {None} \
   CONFIG.Trgt_Link_Speed {4'h2} \
   CONFIG.User_Clk_Freq {125} \
   CONFIG.cfg_ctl_if {false} \
   CONFIG.cfg_fc_if {false} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.cfg_status_if {false} \
   CONFIG.en_ext_clk {false} \
   CONFIG.err_reporting_if {false} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.pipe_mode_sim {None} \
   CONFIG.pl_interface {false} \
   CONFIG.rcv_msg_if {false} \
 ] $pcie_7x_0

  # Create instance: pcie_axi_lite_v1_0_0, and set properties
  set pcie_axi_lite_v1_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:pcie_axi_lite_v1_0:1.0 pcie_axi_lite_v1_0_0 ]
  set_property -dict [ list \
   CONFIG.AXI_BAR_0_ADDR {0x00000000} \
   CONFIG.AXI_BAR_0_MASK {0xFFF00000} \
   CONFIG.BIG_ENDIAN {"1"} \
 ] $pcie_axi_lite_v1_0_0

  # Create instance: rst_dyn_M, and set properties
  set rst_dyn_M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_dyn_M ]

  # Create instance: rst_pcie_7x_0_125M, and set properties
  set rst_pcie_7x_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_pcie_7x_0_125M ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_0

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 ]
  set_property -dict [ list \
   CONFIG.ADC_CONVERSION_RATE {1000} \
   CONFIG.DCLK_FREQUENCY {125} \
 ] $xadc_wiz_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports pcie_clkin] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_mem_intercon_M02_AXI [get_bd_intf_pins axi_mem_intercon/M02_AXI] [get_bd_intf_pins axi_timer_1/S_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M03_AXI [get_bd_intf_pins axi_mem_intercon/M03_AXI] [get_bd_intf_pins clk_wiz/s_axi_lite]
  connect_bd_intf_net -intf_net axi_mem_intercon_M04_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_mem_intercon/M04_AXI]
  connect_bd_intf_net -intf_net pcie_7x_0_m_axis_rx [get_bd_intf_pins pcie_7x_0/m_axis_rx] [get_bd_intf_pins pcie_axi_lite_v1_0_0/s_axis_rx]
  connect_bd_intf_net -intf_net pcie_7x_0_pcie_7x_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins pcie_7x_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net pcie_axi_lite_v1_0_0_M_AXI [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins pcie_axi_lite_v1_0_0/M_AXI]
  connect_bd_intf_net -intf_net pcie_axi_lite_v1_0_0_m_axis_tx [get_bd_intf_pins pcie_7x_0/s_axis_tx] [get_bd_intf_pins pcie_axi_lite_v1_0_0/m_axis_tx]

  # Create port connections
  connect_bd_net -net bram_top_wrapper_0_valid [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins bram_top_wrapper_0/valid]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins axi_mem_intercon/M02_ACLK] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins bram_top_wrapper_0/clk] [get_bd_pins clk_wiz/clk_out1] [get_bd_pins dsp_top_wrapper_0/clk] [get_bd_pins rst_dyn_M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_locked [get_bd_pins bram_top_wrapper_0/enb] [get_bd_pins clk_wiz/locked] [get_bd_pins dsp_top_wrapper_0/enb] [get_bd_pins rst_dyn_M/dcm_locked]
  connect_bd_net -net dsp_top_wrapper_0_valid [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins dsp_top_wrapper_0/valid]
  connect_bd_net -net pcie_7x_0_user_clk_out [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/M03_ACLK] [get_bd_pins axi_mem_intercon/M04_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins clk_wiz/clk_in1] [get_bd_pins clk_wiz/s_axi_aclk] [get_bd_pins pcie_7x_0/user_clk_out] [get_bd_pins pcie_axi_lite_v1_0_0/user_clk] [get_bd_pins rst_pcie_7x_0_125M/slowest_sync_clk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net pcie_7x_0_user_lnk_up [get_bd_pins pcie_7x_0/user_lnk_up] [get_bd_pins pcie_axi_lite_v1_0_0/user_lnk_up]
  connect_bd_net -net pcie_7x_0_user_reset_out [get_bd_pins pcie_7x_0/user_reset_out] [get_bd_pins rst_dyn_M/ext_reset_in] [get_bd_pins rst_pcie_7x_0_125M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins axi_mem_intercon/M02_ARESETN] [get_bd_pins axi_timer_1/s_axi_aresetn] [get_bd_pins rst_dyn_M/peripheral_aresetn]
  connect_bd_net -net rst_pcie_7x_0_125M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/M03_ARESETN] [get_bd_pins axi_mem_intercon/M04_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins clk_wiz/s_axi_aresetn] [get_bd_pins pcie_axi_lite_v1_0_0/M_AXI_ARESETN] [get_bd_pins rst_pcie_7x_0_125M/peripheral_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net sys_rst_n_0_1 [get_bd_ports pcie_reset] [get_bd_pins pcie_7x_0/sys_rst_n]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins pcie_7x_0/sys_clk] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports pcie_clkreq] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00010000 [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00020000 [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00030000 [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] SEG_axi_timer_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00040000 [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs clk_wiz/s_axi_lite/Reg] SEG_clk_wiz_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


