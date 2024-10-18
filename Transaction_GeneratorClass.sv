/******************************************************************
* Author      : Ahmed Raza                                         *
* Date        : 10 September                                       *
* Description : This code defines a transaction and a generator    *
*               class where the generator creates random           *
*               transactions, puts them into a mailbox, and        *
*               triggers an event when finished.                   *
******************************************************************/

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] out;
  
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
  
    function new(input mailbox#(transaction) mbx);
      this.mbx = mbx;
      tr = new();
    endfunction
  
    task run();
      repeat(20) begin
        tr.randomize();
        mbx.put(tr.copy());
        $display("Gen: Value generated successfully");
        #1;
      end
      -> done;
    endtask
  endclass
  