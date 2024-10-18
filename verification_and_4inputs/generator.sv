// Generator Class
class Generator;
  Transaction tr;
  mailbox mbx;
  event completion;

  function new(mailbox mbx);
    this.mbx = mbx;
    tr = new();
  endfunction

  // Generate random values
  task run();
    repeat (15) begin
      tr.randomize();
      mbx.put(tr.copy());
      $display("Generator: Values generated");
      #10;
    end
  endtask
endclass