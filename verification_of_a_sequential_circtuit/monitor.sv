// Monitor Class
class Monitor;
  Transaction tr;
  mailbox mbx;
//   event completion;
  virtual CounterInterface vif;

  function new(mailbox mbx, virtual CounterInterface vif);
    this.mbx = mbx;
//     this.completion = completion;         " event completion,"
    this.vif = vif;
  endfunction

  // Capture and forward DUT output to scoreboard
  task run();
    tr = new();
    forever begin
//       @(completion);
      tr.loadin = vif.loadin;
       tr.rst = vif.rst;
       tr.up = vif.up;
       tr.load = vif.load;
      tr.y = vif.y;
      mbx.put(tr);
      
      $display("Monitor: Data has been passed to scoreboard using mailbox ");
      @( posedge vif.clk);  //Wait for posedge of clk 
    end
  endtask
endclass