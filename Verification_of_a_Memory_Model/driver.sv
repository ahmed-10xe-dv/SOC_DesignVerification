/* 
Driver is responsible for 
    1. Getting the transaction from the Mailbox
    2. Sending this transaction to the DUT via an interface

*/




`define DRIV_IF vif.DRIVER.driver_cb
class driver;
    mailbox mbx_G2D;                                      // Declaring a shared mailbox for communication from the generator to driver
    virtual mem_intf vif;                                 // Declaring a virtiual interface to connect DUT and the driver. 
    int no_transactions;                                  // To count number of transactions

    //Constructor
    function new(mailbox mbx_G2D, virtual mem_intf vif);   // Will get the handles from the environment
        this.mbx_G2D = mbx_G2D;
        this.vif = vif;
        // tr = new();    //Do i really need it? 
    endfunction //new()



    //Task Reset
    task  reset();                    
        wait(vif.reset);
        $display("--------- [DRIVER] Reset Started ---------");
        `DRIV_IF.wr_en <= 0;
        `DRIV_IF.rd_en <= 0;                                   //Have made it non-blocking as it ill assign 0 to all these mentioned signals at the same time and since it is synchronous
        `DRIV_IF.addr <= 0;
        `DRIV_IF.wdata <= 0;
        wait(!vif.reset);
        $display("--------- [DRIVER] Reset Ended ---------");
    endtask //reset 
                                

    //Drive task drives the transaction items to the interface
    task drive();
        forever begin
            Transaction tr;
            `DRIV_IF.wr_en <= 0;
            `DRIV_IF.rd_en <= 0; 
            mbx_G2D.get(tr);
            $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
            @(posedge vif.DRIVER.clk);
            `DRIV_IF.addr <= tr.addr;
            if (tr.wr_en) begin
                `DRIV_IF.wr_en <= tr.wr_en;
                `DRIV_IF.wdata <= tr.wdata;
//                 $display("\tADDR = %0h \tWDATA = %0h",tr.addr,tr.wdata);
                @(posedge vif.DRIVER.clk); 
            end
            if (tr.rd_en) begin
                `DRIV_IF.rd_en <= tr.rd_en;
                @(posedge vif.DRIVER.clk);
                `DRIV_IF.rd_en <= 0;
                @(posedge vif.DRIVER.clk);
                tr.rdata <= `DRIV_IF.rdata;
//                 $display("\tADDR = %0h \tRDATA = %0h",tr.addr,`DRIV_IF.rdata);    
            end
            $display("-----------------------------------------");
            no_transactions++;
          
          $display("[DRIVER %0d] DRIVEN DATA", no_transactions);
          $display(" Address = %0h", tr.addr);
          $display(" Read_En = %0b", tr.rd_en);
          $display(" WRITE_En = %0h", tr.wr_en);
          $display(" WDATA = %0h", tr.wdata);
          $display(" RDATA = %0h", tr.rdata);
          
          
        end
    endtask //drive task
  
  
  task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(vif.reset);
        end
        //Thread-2: Calling drive task
        begin
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
        
        

endclass //driver


