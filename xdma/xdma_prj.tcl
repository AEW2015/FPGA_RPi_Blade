#*****************************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
#
#*****************************************************************************************
if { $argc > 2 } {
    puts "Too many args."
    puts "Please try again."
    break
}


if { $argc < 1 } {
    puts "Using NiteFury Target"
    set Target "nitefury"
} else {
    if { [lindex $argv 0] == "nitefury" } {
        puts "Using NiteFury Target"
        set Target "nitefury"
    } elseif { [lindex $argv 0] == "litefury" } {
        puts "Using LiteFury Target"
        set Target "litefury"
    } elseif { [lindex $argv 0] == "acorn" } {
        puts "Using Acorn Target"
        set Target "acorn"
    } else {
        puts "Unknown Target."
        break
    }
}

if { $argc < 2 } {
    puts "Using memory mapped interface"
    set Interface "mm"
} else {
    if { [lindex $argv 1] == "mm" } {
        puts "Using memory mapped interface"
        set Interface "mm"
    } elseif { [lindex $argv 1] == "stream" } {
        puts "Using streaming interface"
        set Interface "stream"
    } else {
        puts "Unknown Target."
        break
    }
}






# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "xdma_prj"

set _xil_proj_name_ [format "%s_%s_%s" $_xil_proj_name_ $Target $Interface]

puts $_xil_proj_name_



# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "xdma_prj.tcl"




# Create project
if {$Target=="nitefury"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a200tfbg484-2
} elseif {$Target=="litefury"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a100tfgg484-2L
} elseif {$Target=="acorn"} {
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a200tfbg484-3
}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "" -objects $obj
set_property -name "corecontainer.enable" -value "0" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_optional_runs_sta" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "generate_ip_upgrade_log" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_interface_inference_priority" -value "" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "legacy_ip_repo_paths" -value "" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "project_type" -value "Default" -objects $obj
set_property -name "pr_flow" -value "0" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "sim.use_ip_compiled_libs" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "source_mgmt_mode" -value "All" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "target_simulator" -value "XSim" -objects $obj
set_property -name "tool_flow" -value "Vivado" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]


add_files -fileset constrs_1 $origin_dir/../src/xdc/early.xdc
add_files -fileset constrs_1 $origin_dir/../src/xdc/top.xdc




# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

update_compile_order -fileset sources_1

set_property  ip_repo_paths  $origin_dir/../src/ip [current_project]
update_ip_catalog

# Set 'sources_1' fileset file properties for local files
#DO THE BD HERE!
if {$Interface=="mm"} {
source ./bd/mm_bd.tcl
} else {
source ./bd/stream_bd.tcl
}

update_compile_order -fileset sources_1
set wrapper_file [make_wrapper -files [get_files top.bd] -top]
add_files $wrapper_file

update_compile_order -fileset sources_1

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "design_mode" -value "RTL" -objects $obj
set_property -name "edif_extra_search_paths" -value "" -objects $obj
set_property -name "elab_link_dcps" -value "1" -objects $obj
set_property -name "elab_load_timing_constraints" -value "1" -objects $obj
set_property -name "generic" -value "" -objects $obj
set_property -name "include_dirs" -value "" -objects $obj
set_property -name "lib_map_file" -value "" -objects $obj
set_property -name "loop_count" -value "1000" -objects $obj
set_property -name "name" -value "sources_1" -objects $obj
set_property -name "top" -value "top_wrapper" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "verilog_define" -value "" -objects $obj
set_property -name "verilog_uppercase" -value "0" -objects $obj
set_property -name "verilog_version" -value "verilog_2001" -objects $obj
set_property -name "vhdl_version" -value "vhdl_2k" -objects $obj


update_compile_order -fileset sources_1


puts "INFO: Project created:${_xil_proj_name_}"

set_property PROCESSING_ORDER EARLY [get_files early.xdc]

set_property strategy Flow_AlternateRoutability [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1


close_project