class environment;
  
  Generator gen;
  Driver drv;
  Monitor mon;
  Scoreboard scb;

  mailbox mbx_driver, mbx_monitor;
//   event completion;
  virtual CounterInterface vif;

  function new(mailbox mbx_driver, mailbox mbx_monitor, virtual CounterInterface vif);
    
    this.mbx_driver = mbx_driver;
    gen = new(mbx_driver);
    drv = new(mbx_driver, vif);      //Event not provided as an argumenet

    this.mbx_monitor = mbx_monitor;
    mon = new(mbx_monitor, vif);     //Event not provided as an argumenet
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
