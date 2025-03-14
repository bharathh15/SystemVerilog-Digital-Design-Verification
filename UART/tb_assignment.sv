module uart_tb;
    reg clk = 0,rst = 0;
    reg newd;
    reg [7:0] tx_data;
    wire tx;
    wire donetx;
     
    uarttx #(1000000, 9600) dut (clk, rst, newd, tx_data, tx, donetx);
      
    always #5 clk = ~clk;  
     
    reg [7:0] data_tx;
     
    initial 
    begin
        rst = 1;
        repeat(5) @(posedge clk);
        rst = 0;
     
            for(int i = 0 ; i < 10; i++)
            begin
            rst = 0;
            newd = 1;
            tx_data = $urandom();
            
            wait(tx == 0);
            @(posedge dut.uclk);
            
                for(int j = 0; j < 8; j++)
                begin
                @(posedge dut.uclk);
                data_tx = {tx,data_tx[7:1]};
                end
                
            @(posedge donetx);
            
            end
     
     
    end
     
     
    endmodule