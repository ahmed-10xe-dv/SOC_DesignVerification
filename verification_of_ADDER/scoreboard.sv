// Scoreboard Class
class Scoreboard;
    Transaction tr;
    mailbox mbx;
    bit [5:0] expected_result;  
  
    function new(mailbox mbx);
      this.mbx = mbx;
    endfunction
  
    // Compare expected and actual results
    task run();
      forever begin
        mbx.get(tr);
  
        // Reset condition
        if (tr.rst == 1'b1) begin
          expected_result <= 6'b0;
          if (expected_result == tr.out) begin
            $display("PASS: out = %b, expected = %b, valid_out = %b, for reset = %b", 
                      tr.out, expected_result, tr.valid_out, tr.rst);
          end else begin
            $display("FAIL: out = %b, expected = %b, valid_out = %b, for reset = %b", 
                      tr.out, expected_result, tr.valid_out, tr.rst);
          end
        end 
        // Valid input condition (addition)
        else if (tr.valid_in == 1'b1) begin
          expected_result <= tr.in1 + tr.in2;
          if (expected_result == tr.out && tr.valid_out == 1'b1) begin
            $display("PASS: out = %b, expected = %b, valid_out = %b, for valid_in = %b, in1 = %b, in2 = %b", 
                      tr.out, expected_result, tr.valid_out, tr.valid_in, tr.in1, tr.in2);
          end else begin
            $display("FAIL: out = %b, expected = %b, valid_out = %b, for valid_in = %b, in1 = %b, in2 = %b", 
                      tr.out, expected_result, tr.valid_out, tr.valid_in, tr.in1, tr.in2);
          end
        end
      end
    endtask
  endclass
  
  