/*
┌───────────────────────────────────────────────────────────────────────────────┐
│ Description: Transaction, Generator, and Driver classes for a 4-input AND gate│
│ Author: Ahmed Raza                                                            │
│ Date: 10th Sept 2024                                                          │
└───────────────────────────────────────────────────────────────────────────────┘
*/

class transaction;
    randc bit A, B, C, D;  // Randomized inputs for the gates
    bit Y1, Y2, Y;  // Intermediate and final outputs
    
    // Create a copy of the transaction
    function transaction copy();
      transaction tr_copy = new();
      tr_copy.A = this.A;
      tr_copy.B = this.B;
      tr_copy.C = this.C;
      tr_copy.D = this.D;
      tr_copy.Y1 = this.Y1;
      tr_copy.Y2 = this.Y2;
      tr_copy.Y = this.Y;
      return tr_copy;
    endfunction
  endclass
  
  class generator;
    transaction tr;
    mailbox#(transaction) mbx;
    event done;
    
    function new(input mailbox#(transaction) mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
    
    // Randomly generate inputs and send to mailbox
    task run();
      repeat (15) begin  
        tr.randomize();
        if (!mbx.try_put(tr.copy())) // Non-blocking put
          $display("Generator: Mailbox full, skipping...");
        else
          $display("Generator: Inputs A=%0d, B=%0d, C=%0d, D=%0d", tr.A, tr.B, tr.C, tr.D);
        #1;
      end
      ->> done;
    endtask
  endclass
  
  class driver;
    transaction tr;
    mailbox#(transaction) mbx;
    
    function new(input mailbox#(transaction) mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
    
    // Fetch data from mailbox and compute output
    task run();
      forever begin
        if (!mbx.try_get(tr))  // Non-blocking get
          $display("Driver: No new transaction, waiting...");
        else begin
          tr.Y1 = tr.A & tr.B;
          tr.Y2 = tr.C & tr.D;
          tr.Y = tr.Y1 & tr.Y2;
          $display("Driver: Y1=%0d, Y2=%0d, Y=%0d for A=%0d, B=%0d, C=%0d, D=%0d", tr.Y1, tr.Y2, tr.Y, tr.A, tr.B, tr.C, tr.D);
        end
        #1;
      end
    endtask
  endclass
  
  module tb;
    transaction tr;
    mailbox#(transaction) mbx;
    generator gen;
    driver drv;
    
    initial begin
      mbx = new();  // Initialize mailbox
      gen = new(mbx); 
      drv = new(mbx);  
      
      fork
        gen.run();  
        drv.run(); 
      join_any
      
      @gen.done;
      $display("Simulation Completed");
      $finish;
    end
  endmodule
  