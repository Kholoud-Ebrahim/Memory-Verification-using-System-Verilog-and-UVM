module memory #(parameter DATA_WIDTH = 32, DEPTH = 16, ADDR_WIDTH = 4) ( 
  input                        memory_clk,       // memory clock
  input                        memory_rst,       // asynchronous active low reset
  input                        memory_en,        // enable signal
  input                        memory_wr,        // write and read enable
  input      [ADDR_WIDTH-1:0]  memory_addr,      // memory address
  input      [DATA_WIDTH-1:0]  memory_data_in,   // input data to be written 
  output reg                   memory_vld_out,   // valid output for read mode
  output reg[DATA_WIDTH-1:0]   memory_data_out   // output data for read mode
  );

  reg [DATA_WIDTH-1:0] memory_reg [DEPTH];

  always @(posedge memory_clk, negedge memory_rst) begin
    if (!memory_rst) begin  //reset_case
      for (int i = 0; i < ADDR_WIDTH; i++) begin
        memory_reg[i]   <= 0;
      end
      memory_vld_out    <= 'b0;
      memory_data_out   <= 'b0;
    end 
    else if(memory_en) begin
      if (memory_wr) begin //write_case
        memory_reg[memory_addr] <= memory_data_in;
        memory_vld_out          <= 'b0;
        memory_data_out         <= 'b0;
      end
      else begin //read_case
        memory_vld_out   <= 'b1;
        memory_data_out  <= memory_reg[memory_addr];
      end
    end
    else begin //bypass_case
      memory_vld_out     <= 'b0;
      memory_data_out    <= memory_data_in;
    end
  end
endmodule :memory
