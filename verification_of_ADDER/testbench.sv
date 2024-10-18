/*
┌───────────────────────────────────────────────────────────────────────────────┐
│                                                                               │
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
  
  AdderInterface vif();  // Interface instance
  
  adder dut (
    .clock(vif.clk), 
    .reset(vif.rst), 
    .in1(vif.in1), 
    .in2(vif.in2), 
    .valid_in(vif.valid_in), 
    .out(vif.out), 
    .valid_out(vif.valid_out)
  );
  
  environment env;
  mailbox mbx_driver, mbx_monitor;

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
  // Initialize signals
   vif.clk = 0;
  vif.rst = 1;
  vif.valid_in = 0;
  #10;

  // Release reset and start sending valid inputs
  vif.rst = 0;
  vif.valid_in = 1;
  #50;
  
  // Make valid_in 0 after some time to simulate invalid input scenario
  vif.valid_in = 0;
  #30;
  
  // Re-enable valid_in to check correct output behavior
  vif.valid_in = 1;
  #60;

    
  end
  
endmodule
