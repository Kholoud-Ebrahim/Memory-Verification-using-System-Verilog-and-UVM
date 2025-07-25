class memory_scb;
  memory_seq_item item;
  mailbox#(memory_seq_item) mon2scbcov;
  
  int pass_data_rst=0, fail_data_rst=0, pass_data_bypass=0, fail_data_bypass=0, pass_data_read=0, fail_data_read=0;
  int pass_vld=0     , fail_vld=0;
  	
  bit [DATA_WIDTH-1:0] mem [bit [ADDR_WIDTH-1:0]];
    
  function new(mailbox#(memory_seq_item) mon2scbcov);
    this.mon2scbcov =mon2scbcov;
  endfunction:new
  
  task run();
    forever begin
      mon2scbcov.get(item);
      #1step;
      item.print("%memory_scb");

      //reset check:
      if(!item.memory_rst) begin
        if(item.memory_data_out == 0) begin
          $display("PASS_DATA_OUT_RST: rst=%0d, data_out=%0d", item.memory_rst, item.memory_data_out);
          pass_data_rst++;
        end
        else begin
          $error("FAIL_DATA_OUT_RST: rst=%0d, data_out=%0d", item.memory_rst, item.memory_data_out);
          fail_data_rst++;
        end
        
        if(item.memory_vld_out == 0) begin
          $display("PASS_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          pass_vld++;
        end
        else begin
          $error("FAIL_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          fail_vld++;
        end  
      end
      //bypass check:
      else if(item.memory_rst && !item.memory_en) begin
        if(item.memory_data_in == item.memory_data_out) begin
          $display("PASS_BYPASS: rst=%0d, en=%0d, data_in=%0d, data_out=%0d", item.memory_rst, item.memory_en, item.memory_data_in, item.memory_data_out);
          pass_data_bypass++;
        end
        else begin
          $error("FAIL_BYPASS: rst=%0d, en=%0d, data_in=%0d, data_out=%0d", item.memory_rst, item.memory_en, item.memory_data_in, item.memory_data_out);
          fail_data_bypass++;
        end

        if(item.memory_vld_out == 0) begin
          $display("PASS_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          pass_vld++;
        end
        else begin
          $error("FAIL_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          fail_vld++;
        end
      end
      //write check:
      else if(item.memory_rst && item.memory_en && item.memory_wr) begin
        mem[item.memory_addr] = item.memory_data_in;

        $display("mem:%p", mem);    
        if(item.memory_vld_out == 0) begin
          $display("PASS_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          pass_vld++;
        end
        else begin
          $error("FAIL_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          fail_vld++;
        end
      end
      //read check:
      else if(item.memory_rst && item.memory_en && !item.memory_wr) begin
        if(item.memory_data_out == mem[item.memory_addr]) begin
          $display("PASS_READ: rst=%0d, en=%0d, wr=%0d, addr=%0d, data_out=%0d", item.memory_rst, item.memory_en, item.memory_wr, item.memory_addr, item.memory_data_out);
          pass_data_read++;
        end
        else begin
          $error("FAIL_READ: rst=%0d, en=%0d, wr=%0d, addr=%0d, data_out=%0d", item.memory_rst, item.memory_en, item.memory_wr, item.memory_addr, item.memory_data_out);
          fail_data_read++;
        end
        
        if(item.memory_vld_out == 1) begin
          $display("PASS_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          pass_vld++;
        end
        else begin
          $error("FAIL_VLD_OUT: rst=%0d, data_out=%0d", item.memory_rst, item.memory_vld_out);
          fail_vld++;
        end
      end 
    end
  endtask:run
endclass:memory_scb