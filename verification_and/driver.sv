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
  
    // Apply inputs to DUT
    task run();
      tr = new();
      forever begin
        mbx.get(tr);
        vif.A = tr.A;
        vif.B = tr.B;
        vif.C = tr.C;
        vif.D = tr.D;
        $display("Driver: Values applied to DUT: A=%b, B=%b, C=%b, D=%b", tr.A, tr.B, tr.C, tr.D);
        -> completion;
      end
    endtask
  endclass
  