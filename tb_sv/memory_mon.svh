class memory_mon ;
	virtual memory_intf    mon_vif;
  memory_seq_item        item;
	mailbox#(memory_seq_item) mon2scbcov;

	function new (virtual memory_intf vif, mailbox#(memory_seq_item) mon2scbcov);
		this.mon2scbcov = mon2scbcov;
		this.mon_vif    = vif;
	endfunction:new
	
	task run();
		forever begin
			@(posedge mon_vif.memory_clk);
			#1step;
			item = new();
				
			item.memory_rst      <= mon_vif.memory_rst;
			item.memory_en       <= mon_vif.memory_en;
			item.memory_wr       <= mon_vif.memory_wr;
			item.memory_addr     <= mon_vif.memory_addr;
			item.memory_data_in  <= mon_vif.memory_data_in;
			item.memory_vld_out  <= mon_vif.memory_vld_out;
			item.memory_data_out <= mon_vif.memory_data_out;
					
			mon2scbcov.put(item);
			#1step; 
			item.print("memory_mon");      
		end
	endtask:run
endclass:memory_mon