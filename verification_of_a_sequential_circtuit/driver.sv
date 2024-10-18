// Driver Class
class Driver;
  Transaction tr;
  mailbox mbx;
  event completion;
  virtual CounterInterface vif;

  function new(mailbox mbx,  virtual CounterInterface vif);
    this.mbx = mbx;
//     this.completion = completion;     not required atm and this is why haven't passed "event completion," in the new constructor 
    this.vif = vif;
  endfunction

  // Send inputs to DUT
  task run();
    tr = new();
    forever begin
      mbx.get(tr);
      vif.loadin = tr.loadin;
//       vif.y = tr.y;    confused about this why we are not using this? Probably gen is not generating it as a transaction? Oh yes maybe!
     
      
      $display("Driver: Values received from the generator and applied to DUT via an interface ");
//       -> completion;                 Again it is not required as we have not event triggered, will see in future 
      
      @( posedge vif.clk);  //Wait for next posedge of clk 
    end
  endtask
endclass