// Monitor Class
class Monitor;
  Transaction tr;
  mailbox mbx;
  virtual AdderInterface vif;

  function new(mailbox mbx, virtual AdderInterface vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  // Capture and forward DUT output to scoreboard
  task run();
    tr = new();
    forever begin
      
       tr.rst = vif.rst;
       tr.in1 = vif.in1;
       tr.in2 = vif.in2;
       tr.valid_in = vif.valid_in;
       tr.valid_out = vif.valid_out;
      tr.out = vif.out;
      mbx.put(tr);
      
      @( posedge vif.clk);  //Wait for posedge of clk 
    end
  endtask
endclass