`timescale 1ns/1ps
`include "memory_pkg.sv"
import memory_pkg::*;
`include "memory_intf.sv"

module memory_top;
  bit clk;
  
  // clk generation
  initial begin
		forever begin #5 clk = ~clk; end 
	end

  initial begin
		#1000;
    $finish;
	end
  
	memory_intf m_memory_intf(.memory_clk(clk));

  memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut( 
    .memory_clk      (m_memory_intf.memory_clk),
    .memory_rst      (m_memory_intf.memory_rst),
    .memory_en       (m_memory_intf.memory_en),
    .memory_wr       (m_memory_intf.memory_wr),
    .memory_addr     (m_memory_intf.memory_addr),
    .memory_data_in  (m_memory_intf.memory_data_in),
    .memory_vld_out  (m_memory_intf.memory_vld_out),
    .memory_data_out (m_memory_intf.memory_data_out)
  );
  
  memory_env  m_memory_env;
  initial begin
		m_memory_env = new(m_memory_intf);
		m_memory_env.env_run();
	end

  final begin
    $display("========= final report =========");
    $display("[PASS_DATA_OUT_RST] : %0d",m_memory_env.m_memory_scb.pass_data_rst);
    $display("[PASS_DATA_OUT_BYPASS] : %0d",m_memory_env.m_memory_scb.pass_data_bypass);
    $display("[PASS_DATA_OUT_READ] : %0d",m_memory_env.m_memory_scb.pass_data_read);
    $display("[PASS_VLD_OUT] : %0d",m_memory_env.m_memory_scb.pass_vld);
    $display("[FAIL_DATA_OUT_RST] : %0d",m_memory_env.m_memory_scb.fail_data_rst);
    $display("[FAIL_DATA_OUT_BYPASS] : %0d",m_memory_env.m_memory_scb.fail_data_bypass);
    $display("[FAIL_DATA_OUT_READ] : %0d",m_memory_env.m_memory_scb.fail_data_read);
    $display("[FAIL_VLD_OUT] : %0d",m_memory_env.m_memory_scb.fail_vld);
  end
  
	initial begin 
    $dumpfile("wave.vcd");
    $dumpvars;
  end
endmodule:memory_top