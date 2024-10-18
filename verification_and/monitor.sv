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