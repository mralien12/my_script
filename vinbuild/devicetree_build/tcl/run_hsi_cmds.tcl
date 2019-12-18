puts "Running tcl script..."
set cpu_proc $argv
puts "proc=$cpu_proc"
hsi::open_hw_design hdf/hardware_description.hdf
hsi::set_repo_path repo
hsi::create_sw_design device-tree -os device_tree -proc $cpu_proc
hsi::generate_target -dir device-tree
