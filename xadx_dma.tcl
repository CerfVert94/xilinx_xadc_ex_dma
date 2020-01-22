
################################################################
# This is a generated script based on design: xadx_dma
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xadx_dma_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name xadx_dma

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

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: rst_gen
proc create_hier_cell_rst_gen { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_rst_gen() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst tlast_gen_resetn

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create port connections
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins tlast_gen_resetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins slowest_sync_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset_1/aux_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: gpio
proc create_hier_cell_gpio { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_gpio() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  # Create pins
  create_bd_pin -dir O -from 9 -to 0 pkt_length
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 0 -to 0 tlast_gen_resetn

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS {0} \
CONFIG.C_GPIO_WIDTH {32} \
 ] $axi_gpio_1

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {9} \
CONFIG.DOUT_WIDTH {10} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {31} \
CONFIG.DIN_TO {31} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_1_m02_axi [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]

  # Create port connections
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins pkt_length] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins tlast_gen_resetn] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  # Create ports

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {0} \
CONFIG.c_include_mm2s_dre {0} \
CONFIG.c_include_s2mm_dre {1} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axi_mm2s_data_width {32} \
CONFIG.c_m_axi_s2mm_data_width {64} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_1

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {1} \
 ] $axi_interconnect_2

  # Create instance: gpio
  create_hier_cell_gpio [current_bd_instance .] gpio

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: rst_gen
  create_hier_cell_rst_gen [current_bd_instance .] rst_gen

  # Create instance: tlast_gen_0, and set properties
  set tlast_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:tlast_gen:1.0 tlast_gen_0 ]
  set_property -dict [ list \
CONFIG.MAX_PKT_LENGTH {1023} \
CONFIG.TDATA_WIDTH {32} \
 ] $tlast_gen_0

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.2 xadc_wiz_0 ]
  set_property -dict [ list \
CONFIG.ADC_OFFSET_AND_GAIN_CALIBRATION {true} \
CONFIG.ENABLE_AXI4STREAM {true} \
CONFIG.ENABLE_VCCDDRO_ALARM {false} \
CONFIG.ENABLE_VCCPAUX_ALARM {false} \
CONFIG.ENABLE_VCCPINT_ALARM {false} \
CONFIG.OT_ALARM {false} \
CONFIG.SINGLE_CHANNEL_SELECTION {VP_VN} \
CONFIG.USER_TEMP_ALARM {false} \
CONFIG.VCCAUX_ALARM {false} \
CONFIG.VCCINT_ALARM {false} \
 ] $xadc_wiz_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins xadc_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_S2MM [get_bd_intf_pins axi_dma_1/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins gpio/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi_dma_1/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_interconnect_2_M00_AXI [get_bd_intf_pins axi_interconnect_2/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net tlast_gen_0_m_axis [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins tlast_gen_0/m_axis]
  connect_bd_intf_net -intf_net xadc_wiz_0_M_AXIS [get_bd_intf_pins tlast_gen_0/s_axis] [get_bd_intf_pins xadc_wiz_0/M_AXIS]

  # Create port connections
  connect_bd_net -net gpio_pkt_length [get_bd_pins gpio/pkt_length] [get_bd_pins tlast_gen_0/pkt_length]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins rst_gen/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins gpio/s_axi_aresetn] [get_bd_pins rst_gen/peripheral_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_gen/ext_reset_in]
  connect_bd_net -net processing_system7_1_fclk_clk0 [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins gpio/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_gen/slowest_sync_clk] [get_bd_pins tlast_gen_0/aclk] [get_bd_pins xadc_wiz_0/s_axi_aclk] [get_bd_pins xadc_wiz_0/s_axis_aclk]
  connect_bd_net -net rst_gen_tlast_gen_resetn [get_bd_pins rst_gen/tlast_gen_resetn] [get_bd_pins tlast_gen_0/resetn] [get_bd_pins tlast_gen_0/s_axis_tvalid]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins gpio/tlast_gen_resetn] [get_bd_pins rst_gen/aux_reset_in]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs gpio/axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 370 -defaultsOSRD
preplace port Vp_Vn -pg 1 -y 520 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 390 -defaultsOSRD
preplace inst tlast_gen_0 -pg 1 -lvl 4 -y 200 -defaultsOSRD
preplace inst axi_dma_1 -pg 1 -lvl 5 -y 400 -defaultsOSRD
preplace inst xadc_wiz_0 -pg 1 -lvl 3 -y 150 -defaultsOSRD
preplace inst gpio -pg 1 -lvl 3 -y 530 -defaultsOSRD
preplace inst rst_gen -pg 1 -lvl 1 -y 600 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 2 -y 360 -defaultsOSRD
preplace inst axi_interconnect_2 -pg 1 -lvl 6 -y 440 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 7 -y 450 -defaultsOSRD
preplace netloc Conn1 1 0 3 NJ 520 NJ 520 NJ
preplace netloc processing_system7_0_DDR 1 7 1 NJ
preplace netloc axi_dma_1_M_AXI_S2MM 1 5 1 N
preplace netloc xlslice_1_Dout 1 0 4 20 680 NJ 680 NJ 680 1050
preplace netloc processing_system7_1_fclk_clk0 1 0 8 30 510 390 540 720 300 1080 370 1350 490 1700 560 2010 580 2460
preplace netloc axi_interconnect_1_M01_AXI 1 2 3 N 360 NJ 360 NJ
preplace netloc processing_system7_0_M_AXI_GP0 1 1 7 390 200 NJ 310 NJ 310 NJ 310 NJ 310 NJ 310 2460
preplace netloc rst_gen_tlast_gen_resetn 1 1 3 NJ 620 NJ 620 1060
preplace netloc xadc_wiz_0_M_AXIS 1 3 1 1080
preplace netloc tlast_gen_0_m_axis 1 4 1 1360
preplace netloc gpio_pkt_length 1 3 1 1070
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 8 40 670 NJ 610 NJ 610 NJ 610 NJ 610 NJ 610 NJ 610 2450
preplace netloc axi_interconnect_1_M02_AXI 1 2 1 690
preplace netloc proc_sys_reset_0_interconnect_aresetn 1 1 5 380 530 NJ 450 NJ 450 NJ 500 1710
preplace netloc processing_system7_0_FIXED_IO 1 7 1 NJ
preplace netloc proc_sys_reset_0_peripheral_aresetn 1 1 4 N 600 730 440 NJ 440 NJ
preplace netloc axi_interconnect_1_M00_AXI 1 2 1 710
preplace netloc axi_interconnect_2_M00_AXI 1 6 1 N
levelinfo -pg 1 0 210 540 890 1210 1530 1860 2230 2480 -top 0 -bot 690
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


