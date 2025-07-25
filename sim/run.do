#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

vlog -sv +cover=bcefsx  -work work ../rtl/memory.sv

vlog -sv   -work work ../tb_uvm/pkg/memory_top_pkg.sv  +incdir+C:/ver_course/memory/tb_uvm/ +incdir+C:/ver_course/memory/tb_uvm/assertions/ +incdir+C:/ver_course/memory/tb_uvm/coverage/ +incdir+C:/ver_course/memory/tb_uvm/environment/ +incdir+C:/ver_course/memory/tb_uvm/memory_agent/ +incdir+C:/ver_course/memory/tb_uvm/memory_intf/ +incdir+C:/ver_course/memory/tb_uvm/pkg/ +incdir+C:/ver_course/memory/tb_uvm/scoreboard/ +incdir+C:/ver_course/memory/tb_uvm/seq/ +incdir+C:/ver_course/memory/tb_uvm/tests/ +incdir+C:/ver_course/memory/tb_uvm/top/ 

vsim -voptargs="+acc" -debugdb=./vsim.dbg -wlf vsim.wlf -assertdebug  -fsmdebug  -coverage -sv_seed 10 -t ps work.memory_top_wrap +UVM_VERBOSITY=UVM_LOW +UVM_MAX_QUIT_COUNT=20 +UVM_OBJECTION_TRACE +UVM_TESTNAME=write_read_test

set NoQuitOnFinish 1
onbreak {resume}

add wave  \
-radix unsigned sim:/memory_top_wrap/m_memory_intf/memory_clk \
sim:/memory_top_wrap/m_memory_intf/memory_rst \
sim:/memory_top_wrap/m_memory_intf/memory_en \
sim:/memory_top_wrap/m_memory_intf/memory_wr \
sim:/memory_top_wrap/m_memory_intf/memory_addr \
sim:/memory_top_wrap/m_memory_intf/memory_data_in \
sim:/memory_top_wrap/m_memory_intf/memory_vld_out \
sim:/memory_top_wrap/m_memory_intf/memory_data_out

add wave  -divider scb
add wave /memory_top_pkg::memory_scb::write/rst_check_ass
add wave /memory_top_pkg::memory_scb::write/read_check_ass
add wave  -divider assertions
add wave /memory_top_wrap/dut/memory_assertions_inst/reset_vld_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/reset_data_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/bypass_vld_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/bypass_data_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/write_vld_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/write_data_out_ass
add wave /memory_top_wrap/dut/memory_assertions_inst/read_vld_out_ass
log /* -r
run -all

coverage attribute -name TESTNAME -value write_read_test
coverage save ./write_read_test_cov.ucdb

vcover report ./write_read_test_cov.ucdb  -cvg -details -output     ./func_cov.txt
vcover report ./write_read_test_cov.ucdb  -details -output          ./code_cov.txt
vcover report ./write_read_test_cov.ucdb  -details -assert  -output ./assertion_cov.txt
