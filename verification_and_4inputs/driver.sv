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

  // Send inputs to DUT
  task run();
    tr = new();
    forever begin
      mbx.get(tr);
      vif.input_a = tr.input_a;
      vif.input_b = tr.input_b;
      $display("Driver: Values applied to DUT");
      -> completion;
    end
  endtask
endclass