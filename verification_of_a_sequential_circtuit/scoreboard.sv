// Scoreboard Class
class Scoreboard;
  Transaction tr;
  mailbox mbx;
  bit [7:0] expected_result;   

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  // Compare expected and actual results
  task run();
    forever begin
      mbx.get(tr);

// Reset condition
        if (tr.rst == 1'b1) begin
            expected_result <= 8'b00000000;
            if (expected_result == tr.y) begin
                $display("PASS: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 								expected_result, tr.rst, tr.load, tr.up);
            end else begin
                $display("FAIL: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 								expected_result, tr.rst, tr.load, tr.up);
            end
        end 
      

// Load condition 
      else if (tr.load == 1'b1) begin
            expected_result <= tr.loadin;
            if (expected_result == tr.y) begin
                $display("PASS: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 								expected_result, tr.rst, tr.load, tr.up);
            end else begin
                $display("FAIL: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 								expected_result, tr.rst, tr.load, tr.up);
            end
        end 
   
// Increment or hold condition
      else begin
            
            if (tr.up == 1'b1) begin
                expected_result <= expected_result + 1;
            end
            if (expected_result == tr.y) begin
                $display("PASS: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 							expected_result, tr.rst, tr.load, tr.up);
            end else begin
                $display("FAIL: y = %b, expected = %b, for rst = %b, load = %b, up = %b", tr.y, 						expected_result, tr.rst, tr.load, tr.up);
            end
        end
    end
  endtask
endclass
