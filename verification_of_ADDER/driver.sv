// Driver Class
class Driver;
  Transaction tr;
  mailbox mbx;
  event completion;
  virtual AdderInterface vif;

  function new(mailbox mbx,  virtual AdderInterface vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  // Send inputs to DUT
  task run();
    tr = new();
    forever begin
      mbx.get(tr);
      vif.in1 = tr.in1;
      vif.in2 = tr.in2;
      @( posedge vif.clk); 
    end
  endtask
endclass