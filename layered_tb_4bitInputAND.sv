module AND1(input logic  A, B, C, D,
    output logic Y);
logic Y1, Y2;

assign Y1 = A & B;
assign Y2 = C & D;
assign Y = Y1 & Y2;

endmodule 


/*
┌───────────────────────────────────────────────────────────────────────────────┐
│ Description: Transaction, Generator, and Driver classes for a 4-input AND gate│
│ Author: Ahmed Raza                                                            │
│ Date: 10th Sept 2024                                                          │
└───────────────────────────────────────────────────────────────────────────────┘
*/

interface and_in();
    logic A,B,C,D, Y;
  endinterface
  
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
    
    virtual and_in v_and_in;
    
    transaction tr;
    mailbox#(transaction) mbx;
    
    function new(input mailbox#(transaction) mbx, virtual and_in v_and_in);
      this.mbx = mbx;
      this.v_and_in = v_and_in;
      tr = new();
    endfunction
    
    // Fetch data from mailbox and compute output
    task run();
      forever begin
        if (!mbx.try_get(tr))  // Non-blocking get
          $display("Driver: No new transaction, waiting...");
        else begin
          v_and_in.A = tr.A;
          v_and_in.B= tr.B;
          v_and_in.C= tr.C;
          v_and_in.D= tr.D;
        end
        #1;
      end
      $display("Driver: Data Received from generator");
    endtask
  endclass
  
  module tb;
    transaction tr;
    mailbox#(transaction) mbx;
    generator gen;
    driver drv;
    
    and_in v_and_in();
    AND1 dut(v_and_in.A, v_and_in.B, v_and_in.C, v_and_in.D, v_and_in.Y);
    
    initial begin
      mbx = new();  // Initialize mailbox
      gen = new(mbx); 
      drv = new(mbx, v_and_in);
      
      fork
        gen.run();  
        drv.run(); 
      join_any
      
      @gen.done;
      $display("Simulation Completed");
      $finish;
    end
    
    initial begin
      $dumpvars;
      $dumpfile("dump.vcd");
    end
    
  endmodule
  