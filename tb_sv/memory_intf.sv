interface memory_intf(input logic memory_clk);
  logic                    memory_rst;       // asynchronous active low reset
  logic                    memory_en;        // enable signal
  logic                    memory_wr;        // write and read enable
  logic  [ADDR_WIDTH-1:0]  memory_addr;      // memory address
  logic  [DATA_WIDTH-1:0]  memory_data_in;   // logic data to be written 
  logic                    memory_vld_out;   // valid output for read mode
  logic  [DATA_WIDTH-1:0]  memory_data_out;  // output data for read mode
endinterface:memory_intf