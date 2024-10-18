// Generator Class
class Generator;
  Transaction tr;
  mailbox mbx;
//   event completion;           //Not required atm

  function new(mailbox mbx);
    this.mbx = mbx;
    tr = new();
  endfunction

  // Generate random values
  task run();
    repeat (15) begin
      tr.randomize();                        //Can Make it more good by using assertion if the randomization fails 
      mbx.put(tr.copy());        // Can make it more good by using try.put and then usg if else if it fails or even assertioon s 
      $display("Generator: Transactions have been generated and added in the mailbox successfully");
      #10;
    end
  endtask
endclass