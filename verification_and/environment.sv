class environment;
  
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard scb;
  
    mailbox mbx_driver, mbx_monitor;
    event completion;
    virtual AndGateInterface vif;
  
    function new(mailbox mbx_driver, mailbox mbx_monitor, virtual AndGateInterface vif);
      
      this.mbx_driver = mbx_driver;
      gen = new(mbx_driver);
      drv = new(mbx_driver, completion, vif);
  
      this.mbx_monitor = mbx_monitor;
      mon = new(mbx_monitor, completion, vif);
      scb = new(mbx_monitor);
  
    endfunction
    
    task run();
      fork
        gen.run();
        drv.run();
        mon.run();
        scb.run();
      join_any
      
    endtask
  endclass
  