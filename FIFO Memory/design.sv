module FIFO(input clk, rst, wr, rd,
            input [7:0] din, output reg [7:0] dout,
            output empty, full);
  
  
  reg [3:0] rptr = 0;
  reg [3:0] wptr = 0;
  reg [4:0] cnt;
  
  reg [7:0] memory [15:0];
  
  always@(posedge clk)
    begin
     if (rst == 1'b1)
        begin
          wptr <= 0;
          rptr <= 0;
          cnt  <= 0;
        end
    else if(rd == 1'b1 && !empty) begin
      dout <= memory[rptr];
      rptr <= rptr +1;
      cnt <= cnt - 1;
    end
  
  else if (wr == 1'b1 &&!full) begin
    memory[wptr] <= din;
    wptr <= wptr+1;
    cnt <= cnt +1;
  end
  
    end
  assign empty = (cnt == 0) ? 1'b1 : 1'b0;
  assign full  = (cnt == 16) ? 1'b1 : 1'b0;
 
endmodule
 
      interface fifo_if;
        logic clock,rd, wr;
        logic full, empty;
        logic [7:0] data_in;
        logic [7:0] data_out;
        logic rst;
      endinterface


        