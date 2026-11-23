# Rebuild the minimal Vivado RTL project from tracked source files.
# Run from repository root: vivado -mode batch -source fpga/create_project.tcl
set script_dir [file dirname [file normalize [info script]]]
set root [file dirname $script_dir]
create_project butterworth_vhdl [file join $root build butterworth_vhdl] -part xc7a100tcsg324-1 -force
set_property target_language VHDL [current_project]

foreach name {filter band_filter derivation tempo_1us adc_filter adc_band_filter} {
    set f [file join $script_dir rtl "${name}.vhd"]
    add_files -fileset sources_1 -norecurse $f
}
set xci [file join $script_dir ip xadc_wiz_0.xci]
add_files -fileset sources_1 -norecurse $xci

foreach name {tb_filter tb_band_filter tb_derivation} {
    add_files -fileset sim_1 -norecurse [file join $script_dir tb "${name}.vhd"]
}
set xdc [file join $script_dir constraints Artix7_XDC_master.xdc]
add_files -fileset constrs_1 -norecurse $xdc
set_property top adc_filt [get_filesets sources_1]
set_property top tb_filter [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "Vivado source project created: build/butterworth_vhdl"
puts "Use adc_band_filt and tb_band_filter for the band-pass variant."
puts "Check IP configuration and original board pin constraints before implementation."
