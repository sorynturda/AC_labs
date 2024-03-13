# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/sorin/Desktop/AC_labs/03/ROM/ROM.cache/wt [current_project]
set_property parent.project_path /home/sorin/Desktop/AC_labs/03/ROM/ROM.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/sorin/Desktop/AC_labs/03/ROM/ROM.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/sorin/Desktop/AC_labs/SSD.vhd
  /home/sorin/Desktop/AC_labs/MPG.vhd
  /home/sorin/Desktop/AC_labs/03/ROM/ROM.srcs/sources_1/new/test_env.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/sorin/Desktop/AC_labs/NexysA7_test_env.xdc
set_property used_in_implementation false [get_files /home/sorin/Desktop/AC_labs/NexysA7_test_env.xdc]


synth_design -top test_env -part xc7a100tcsg324-1


write_checkpoint -force -noxdef test_env.dcp

catch { report_utilization -file test_env_utilization_synth.rpt -pb test_env_utilization_synth.pb }
