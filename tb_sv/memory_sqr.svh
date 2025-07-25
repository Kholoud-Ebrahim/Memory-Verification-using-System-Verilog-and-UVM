class memory_sqr;
  memory_seq_item           item;
  mailbox#(memory_seq_item) sqr2drv;
  
  int 			      	   write_tr_num;    // number of write transactions
  int 				         read_tr_num;     // number of read transactions
  int    			         bypass_tr_num;   // number of bypass transactions
  bit [ADDR_WIDTH-1:0] wr_addr_q[$];    // queue of written addresses
  int 				         wr_addr_q_size;  // queue size of the written addresses
  int 			           rand_addr;       // randomized addresses
  
  function new(mailbox#(memory_seq_item) sqr2drv);
    this.sqr2drv  = sqr2drv;
		write_tr_num  = 40;
		read_tr_num   = 30;
    bypass_tr_num = 20;
	endfunction:new
	
	task run();
		repeat(write_tr_num) begin
			item = new();
			ass1: assert(item.randomize() with {
				memory_rst  == 1; 
				memory_en   == 1; 
				memory_wr   == 1;
			});
			wr_addr_q.push_back(item.memory_addr);
			sqr2drv.put(item);
			item.print("memory_sqr");
		end
      
		$display("wr_addr_q: %p", wr_addr_q);
      
		wr_addr_q_size = wr_addr_q.size();
		$display("wr_addr_q_size: %0d", wr_addr_q_size);
      
		repeat(read_tr_num) begin
			item = new();
			
			rand_addr = $urandom_range(0, wr_addr_q_size-1);
			$display("rand_addr: %0d", rand_addr);
			
			ass2: assert(item.randomize() with {
				memory_rst  == 1; 
				memory_en   == 1; 
				memory_wr   == 0;
				memory_addr == wr_addr_q[rand_addr];
			});
			sqr2drv.put(item);
			item.print("memory_sqr");
		end
      
		repeat(bypass_tr_num) begin
			item = new();
			
			ass3: assert(item.randomize() with {
				memory_rst  == 1; 
				memory_en   == 0; 
			});
			sqr2drv.put(item);
			item.print("memory_sqr");
		end
      
		repeat(1) begin
			item = new();
			
			ass4: assert(item.randomize() with {
				memory_rst  == 0; 
			});
			sqr2drv.put(item);
			item.print("memory_sqr");
		end
  endtask:run
endclass: memory_sqr