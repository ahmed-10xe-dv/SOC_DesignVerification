module AND1(input logic  A, B, C, D,
    output logic Y);
logic Y1, Y2;

assign Y1 = A & B;
assign Y2 = C & D;
assign Y = Y1 & Y2;

endmodule 

/*
┌───────────────────────────────────────────────────────────────────────────────┐
│ Description: Testbench for 4-input AND gate with Transaction, Generator, Driver│
│ Monitor, and Scoreboard classes                                                │
│ Author: Ahmed Raza                                                             │
│ Date: 24th September 2024                                                      │
└───────────────────────────────────────────────────────────────────────────────┘
*/

// Transaction Class
class Transaction;
    randc bit A, B, C, D;  // Four inputs for AND gate
    bit Y;                 // Output result
  
    function Transaction copy();
      Transaction t_copy = new();
      t_copy.A = this.A;
      t_copy.B = this.B;
      t_copy.C = this.C;
      t_copy.D = this.D;
      t_copy.Y = this.Y;
      return t_copy;
    endfunction
  endclass
  
  // Generator Class
  class Generator;
    Transaction tr;
    mailbox mbx;
    event completion;
  
    function new(mailbox mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
  
    // Generate random input values
    task run();
      repeat (15) begin
        tr.randomize();
        mbx.put(tr.copy());
        $display("Generator: Values generated");
        #10;
      end
    endtask
  endclass
  
  // Interface to connect to DUT
  interface AndGateInterface();
    logic A, B, C, D;   // Inputs for the 4-input AND gate
    logic Y;            // Output result  
  endinterface
  
  // Driver Class
  class Driver;
    Transaction tr;
    mailbox mbx;
    event completion;
    virtual AndGateInterface vif;
  
    function new(mailbox mbx, event completion, virtual AndGateInterface vif);
      this.mbx = mbx;
      this.completion = completion;
      this.vif = vif;
    endfunction
  
    // Apply inputs to DUT
    task run();
      tr = new();
      forever begin
        mbx.get(tr);
        vif.A = tr.A;
        vif.B = tr.B;
        vif.C = tr.C;
        vif.D = tr.D;
        $display("Driver: Values applied to DUT: A=%b, B=%b, C=%b, D=%b", tr.A, tr.B, tr.C, tr.D);
        -> completion;
      end
    endtask
  endclass
  
  // Monitor Class
  class Monitor;
    Transaction tr;
    mailbox mbx;
    event completion;
    virtual AndGateInterface vif;
  
    function new(mailbox mbx, event completion, virtual AndGateInterface vif);
      this.mbx = mbx;
      this.completion = completion;
      this.vif = vif;
    endfunction
  
    // Capture and forward DUT output to scoreboard
    task run();
      tr = new();
      forever begin
        @(completion);
        tr.A = vif.A;
        tr.B = vif.B;
        tr.C = vif.C;
        tr.D = vif.D;
        tr.Y = vif.Y;
        mbx.put(tr);
      end
    endtask
  endclass
  
  // Scoreboard Class
  class Scoreboard;
    Transaction tr;
    mailbox mbx;
    bit expected_Y;
  
    function new(mailbox mbx);
      this.mbx = mbx;
    endfunction
  
    // Compare expected and actual results
    task run();
      forever begin
        mbx.get(tr);
        expected_Y = (tr.A & tr.B) & (tr.C & tr.D);  // Expected AND operation
        if (expected_Y == tr.Y) begin
          $display("PASS: A=%b, B=%b, C=%b, D=%b, Y=%b, expected=%b", tr.A, tr.B, tr.C, tr.D, tr.Y, expected_Y);
        end else begin
          $display("FAIL: A=%b, B=%b, C=%b, D=%b, Y=%b, expected=%b", tr.A, tr.B, tr.C, tr.D, tr.Y, expected_Y);
        end
      end
    endtask
  endclass
  
  // Testbench Module
  module tb;
  
    Generator gen;
    Driver drv;
    Monitor mon;
    Scoreboard scb;
  
    mailbox mbx_driver, mbx_monitor;
    event completion;
  
    AndGateInterface vif();  // Interface instance
    AND1 dut(vif.A, vif.B, vif.C, vif.D, vif.Y);  // Connect to DUT with 4 inputs
  
    // Dump simulation waveforms
    initial begin    
      $dumpvars;
      $dumpfile("dump.vcd");
    end 
  
    initial begin
      // Instantiate and start the testbench components
      mbx_driver = new();
      gen = new(mbx_driver);
      drv = new(mbx_driver, completion, vif);
  
      mbx_monitor = new();
      mon = new(mbx_monitor, completion, vif);
      scb = new(mbx_monitor);
  
      fork
        gen.run();
        drv.run();
        mon.run();
        scb.run();
      join_any
    end
  
  endmodule
  