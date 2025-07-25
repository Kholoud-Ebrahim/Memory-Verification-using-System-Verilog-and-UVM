class memory_env;
  memory_sqr  m_memory_sqr;
	memory_drv  m_memory_drv;
	memory_mon  m_memory_mon;
	memory_scb  m_memory_scb;
  
	mailbox#(memory_seq_item) mb1_drv;
	mailbox#(memory_seq_item) mb2_mon;
  
	virtual memory_intf    env_vif;

	function new(virtual memory_intf vif);
		this.env_vif= vif;
		mb1_drv = new();
		mb2_mon = new();
		m_memory_sqr = new(.sqr2drv(mb1_drv));
		m_memory_drv = new(.sqr2drv(mb1_drv), .vif(vif));
		m_memory_mon = new(.vif(vif), .mon2scbcov(mb2_mon));
		m_memory_scb = new(.mon2scbcov(mb2_mon));
	endfunction

	task env_run();
		fork
			m_memory_sqr.run();
			m_memory_drv.run();
			m_memory_mon.run();
			m_memory_scb.run();
    join_any
	endtask:env_run
endclass: memory_env