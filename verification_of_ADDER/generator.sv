// Generator Class
class Generator;
  Transaction tr;
  mailbox mbx;
  function new(mailbox mbx);
    this.mbx = mbx;
    tr = new();
  endfunction

  // Generate random values
  task run();
    repeat (15) begin
      tr.randomize();                        
      mbx.put(tr.copy());        
      #10;
    end
  endtask
endclass