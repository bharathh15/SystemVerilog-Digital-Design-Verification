`timescale 1ns / 1ps
 
 
module uarttx
#(
parameter clk_freq = 1000000,
parameter baud_rate = 9600
)
(
input clk,rst,
input newd,
input [7:0] tx_data,
output reg tx,
output reg donetx
);
 
  localparam clkcount = (clk_freq/baud_rate); ///x
  
integer count = 0;
integer counts = 0;
 
reg uclk = 0;
  
enum bit[1:0] {idle = 2'b00, start = 2'b01, transfer = 2'b10, send_parity = 2'b11} state;
 
 ///////////uart_clock_gen
  always@(posedge clk)
    begin
      if(count < clkcount/2)
        count <= count + 1;
      else begin
        count <= 0;
        uclk <= ~uclk;
      end 
    end
  
  
  reg [7:0] din;
  reg parity = 0; /// store odd parity
  ////////////////////Reset decoder
  
  
  always@(posedge uclk)
    begin
      if(rst) 
      begin
        state <= idle;
      end
     else
     begin
     case(state)
     
     //////detect new data and start transmission
       idle:
         begin
           counts <= 0;
           tx <= 1'b1;
           donetx <= 1'b0;
           
           if(newd) 
           begin
             state <= transfer;
             din <= tx_data;
             tx <= 1'b0; 
             parity <= ~^tx_data; 
           end
           else
             state <= idle;       
         end
       
 
      ///// wait till transmission of data is completed
      transfer: begin 
          
        if(counts <= 7) 
        begin
           counts <= counts + 1;
           tx     <= din[counts];
           state  <= transfer;
        end
        else 
        begin
           counts <= 0;
           tx     <= parity;
           state  <= send_parity;
        end
      end
      
      ////send parity and move to idle
      send_parity: 
      begin
      tx     <= 1'b1;
      state  <= idle;
      donetx <= 1'b1;
      end
      
      default : state <= idle;
      
    endcase
  end
end
 
endmodule