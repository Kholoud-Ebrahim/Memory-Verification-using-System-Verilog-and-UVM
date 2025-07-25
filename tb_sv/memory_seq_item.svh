class memory_seq_item;
  // dut inputs
  rand logic                    memory_rst;
  rand logic                    memory_en;
  rand logic                    memory_wr;
  rand logic  [ADDR_WIDTH-1:0]  memory_addr;
  rand logic  [DATA_WIDTH-1:0]  memory_data_in;
  // dut outputs
  logic                         memory_vld_out;
  logic  [DATA_WIDTH-1:0]       memory_data_out;

  // constraints
  constraint rst_c {
    soft memory_rst dist {1:= 70, 0:= 30};
  }

  task print(input string class_name);
    $display("******************************");
    $display("%0s class @%0t inputs:",class_name,$realtime);
    $display("memory_rst      = %0d", memory_rst);
    $display("memory_en       = %0d", memory_en);
    $display("memory_wr       = %0d", memory_wr);
    $display("memory_addr     = %0d", memory_addr);
    $display("memory_data_in  = %0d", memory_data_in);
    if(class_name !="memory_sqr" && class_name !="memory_drv") begin
      $display("outputs:");
      $display("memory_vld_out  = %0d", memory_vld_out);
      $display("memory_data_out = %0d", memory_data_out);
    end
    $display("******************************");
  endtask:print
endclass:memory_seq_item