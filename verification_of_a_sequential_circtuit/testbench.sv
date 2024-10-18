/*
┌───────────────────────────────────────────────────────────────────────────────┐
│ Description:                                                                  │
│ Author: Ahmed Raza                                                            │
│ Date: 24th September 2024                                                     │
└───────────────────────────────────────────────────────────────────────────────┘
*/

`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"




// Testbench Module
module tb;
  
  CounterInterface vif();  // Interface instance
  counter dut(vif.clk, vif.rst, vif.up, vif.load, vif.loadin, vif.y);  // Connect to DUT portmapping 
  
  
  environment env;
  mailbox mbx_driver, mbx_monitor;

  // Dump simulation waveforms
  initial begin    
    $dumpvars;
    $dumpfile("dump.vcd");
  end 

  initial begin
    
    mbx_driver= new();
    mbx_monitor = new();
    env = new(mbx_driver, mbx_monitor, vif);

    env.run();
    #150;
    $finish;
  end

  
always #5 vif.clk = ~vif.clk;
  
  
  initial begin
    vif.clk = 0;
    vif.rst = 1;
    vif.load = 0;
    vif.up = 0;
    #10
    
    vif.rst = 0;
    vif.load = 1;
    #50;
    
     vif.load = 0;
    vif.up = 1;
    
    #70;
     vif.up = 0;
    
    
  end
  
endmodule
