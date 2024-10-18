/*
┌───────────────────────────────────────────────────────────────────────────────┐
│ Description: Testbench for 4-bit AND gate with Transaction, Generator, Driver │
│ Monitor, and Scoreboard classes                                               │
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
  
  AndGateInterface vif();  // Interface instance
  and1 dut(vif.input_a, vif.input_b, vif.output_res);  // Connect to DUT
  
  
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
  end

endmodule
