/*
Monitor is responsible for 
    1. samples the interface signals 
    2. Converts the signal level activity to transaction level
    3. Send the sampled transaction to the scoreboard via mailbox
    
*/

`define MON_IF vif.MONITOR.monitor_cb
class monitor;
   
    virtual mem_intf vif;            //Virtual Interface to connect with the DUT
    mailbox mbx_M2Sc;
    
    function new(virtual mem_intf vif, mailbox mbx_M2Sc);
        this.vif = vif;
        this.mbx_M2Sc = mbx_M2Sc;
    endfunction //new()

    task  main();
        forever begin
          Transaction tr;
          tr = new();
            @(posedge vif.MONITOR.clk);
          wait(`MON_IF.rd_en || `MON_IF.wr_en);
            tr.addr = `MON_IF.addr;
            tr.wr_en = `MON_IF.wr_en;
            tr.wdata = `MON_IF.wdata;
            if (`MON_IF.rd_en) begin
                tr.rd_en = `MON_IF.rd_en;
              @(posedge vif.MONITOR.clk);
              @(posedge vif.MONITOR.clk);                     //Why 2 clocks btw?
                tr.rdata = `MON_IF.rdata;
            end
            mbx_M2Sc.put(tr);
          
          $display("[MONITOR] SAMPLED DATA");
          $display(" Address = %0h", tr.addr);
          $display(" Read_En = %0b", tr.rd_en);
          $display(" WRITE_En = %0h", tr.wr_en);
          $display(" WDATA = %0h", tr.wdata);
          $display(" RDATA = %0h", tr.rdata);
          
        end
        
    endtask //main

endclass //monitor