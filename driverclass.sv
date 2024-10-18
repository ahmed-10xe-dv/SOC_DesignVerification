/******************************************************************
* Author      : Ahmed Raza                                         *
* Date        : 10 September                                       *
* Description : This SystemVerilog code defines three classes:     *
*               transaction, generator, and driver. The generator  *
*               produces randomized transactions and sends them    *
*               via a mailbox to the driver, which processes the   *
*               transactions.                                      *
******************************************************************/

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] out;
  
    // Copy function to duplicate a transaction object
    function transaction copy;
      transaction tr_copy = new();
      tr_copy.a = this.a;
      tr_copy.b = this.b;
      tr_copy.out = this.out;
      return tr_copy;
    endfunction
  
  endclass
  
  class generator;
    transaction tr;
    mailbox#(transaction) mbx;
    event done;
  
    // Constructor to initialize the generator with a mailbox
    function new(input mailbox#(transaction) mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
  
    // Task to generate and send 20 random transactions
    task run();
      repeat(20) begin
        tr.randomize();
        mbx.put(tr.copy());   
        $display("Generator: Value a is :: %0d \t b is :: %0d", tr.a, tr.b);
        #1;
      end
      ->> done;  // Signal completion
    endtask
  endclass
  
  class driver;
    transaction tr;
    mailbox#(transaction) mbx;
  
    // Constructor to initialize the driver with a mailbox
    function new(input mailbox#(transaction) mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
  
    // Task to continuously receive and process transactions
    task run();
      forever begin
        tr = new();
        mbx.get(tr);  // Receive a transaction from the mailbox
        $display("Driver:    Value a is :: %0d \t b is :: %0d", tr.a, tr.b);
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
      mbx = new();  // Create mailbox
      gen = new(mbx);  // Instantiate generator
      drv = new(mbx);  // Instantiate driver
      fork 
        gen.run();  // Start generator
        drv.run();  // Start driver
      join_any
      @gen.done;  // Wait for generator to complete
      $display("Transaction Completed Successfully");
    end
    
  endmodule
  