class environment;
  
  Generator gen;
  Driver drv;
  Monitor mon;
  Scoreboard scb;

  mailbox mbx_driver, mbx_monitor;
  virtual AdderInterface vif; 

  // Constructor for the environment class
  function new(mailbox mbx_driver, mailbox mbx_monitor, virtual AdderInterface vif);
    
    this.mbx_driver = mbx_driver;
    gen = new(mbx_driver);
    drv = new(mbx_driver, vif);    

    this.mbx_monitor = mbx_monitor;
    mon = new(mbx_monitor, vif); 
    scb = new(mbx_monitor);

  endfunction
  
  // Task to run the environment
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_any
    
  endtask
endclass
