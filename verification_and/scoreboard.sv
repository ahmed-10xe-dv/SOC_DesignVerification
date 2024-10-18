
// Scoreboard Class
class Scoreboard;
    Transaction tr;
    mailbox mbx;
    bit expected_Y;
  
    function new(mailbox mbx);
      this.mbx = mbx;
    endfunction
  
    // Compare expected and actual results
    task run();
      forever begin
     
        mbx.get(tr);
        expected_Y = (tr.A & tr.B) & (tr.C & tr.D);  // Expected AND operation
        if (expected_Y == tr.Y) begin
          $display("PASS: A=%b, B=%b, C=%b, D=%b, Y=%b, expected=%b", tr.A, tr.B, tr.C, tr.D, tr.Y, expected_Y);
        end else begin
          $display("FAIL: A=%b, B=%b, C=%b, D=%b, Y=%b, expected=%b", tr.A, tr.B, tr.C, tr.D, tr.Y, expected_Y);
        end
      end
    endtask
  endclass