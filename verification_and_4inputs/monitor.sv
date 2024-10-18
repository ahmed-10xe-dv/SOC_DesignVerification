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
      tr.input_a = vif.input_a;
      tr.input_b = vif.input_b;
      tr.result = vif.output_res;
      mbx.put(tr);
    end
  endtask
endclass