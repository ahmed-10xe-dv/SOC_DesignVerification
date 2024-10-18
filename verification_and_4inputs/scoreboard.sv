// Scoreboard Class
class Scoreboard;
  Transaction tr;
  mailbox mbx;
  bit [3:0] expected_result;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  // Compare expected and actual results
  task run();
    forever begin
      mbx.get(tr);
      expected_result = tr.input_a & tr.input_b;  // Expected result
      if (expected_result == tr.result) begin
        $display("PASS: a=%b, b=%b, out=%b, expected=%b", tr.input_a, tr.input_b, tr.result, expected_result);
      end else begin
        $display("FAIL: a=%b, b=%b, out=%b, expected=%b", tr.input_a, tr.input_b, tr.result, expected_result);
      end
    end
  endtask
endclass

// Testbe