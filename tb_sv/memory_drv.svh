class memory_drv;
  virtual memory_intf         drv_vif;
	memory_seq_item           item;
	mailbox#(memory_seq_item) sqr2drv;

  function new(mailbox#(memory_seq_item) sqr2drv, virtual memory_intf vif);
    this.sqr2drv = sqr2drv;
    this.drv_vif = vif;
  endfunction:new
  
  task reset();
    drv_vif.memory_rst     <= 'b1;
    drv_vif.memory_en      <= 'b0;
    drv_vif.memory_wr      <= 'b0;
    drv_vif.memory_addr    <= 'b0;
    drv_vif.memory_data_in <= 'b0;
    @(posedge drv_vif.memory_clk);
    drv_vif.memory_rst     <= 'b0;
    drv_vif.memory_en      <= 'b0;
    drv_vif.memory_wr      <= 'b0;
    drv_vif.memory_addr    <= 'b0;
    drv_vif.memory_data_in <= 'b0;
    @(negedge drv_vif.memory_clk);
    drv_vif.memory_rst     <= 'b1;
    drv_vif.memory_en      <= 'b0;
    drv_vif.memory_wr      <= 'b0;
    drv_vif.memory_addr    <= 'b0;
    drv_vif.memory_data_in <= 'b0;
  endtask:reset
	
	task run(); 
    reset();
    forever begin
      @(negedge drv_vif.memory_clk);
      sqr2drv.get(item);
      drv_vif.memory_rst     <= item.memory_rst;
      drv_vif.memory_en      <= item.memory_en;
      drv_vif.memory_wr      <= item.memory_wr;
      drv_vif.memory_addr    <= item.memory_addr;
      drv_vif.memory_data_in <= item.memory_data_in;
      item.print("memory_drv");
    end
  endtask:run
endclass: memory_drv