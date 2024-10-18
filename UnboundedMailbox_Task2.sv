// ---------------------------------------
// Filename    : unbound_mailbox.sv
// Author      : Ahmed Raza
// Description : This module demonstrates the use of an unbounded mailbox in 
//               SystemVerilog. One process (p1) inserts random integers 
//               into the mailbox, while another process (p2) attempts to 
//               peek and then retrieve the data.
// Date        : 6 September 2024
// ---------------------------------------

module unbound_mailbox;


    mailbox#(int) mb = new();
  
  
    task p1;
      int count;
      repeat (15) begin
        count = $urandom_range(10, 100);  // Generate a random integer between 10 and 100
        mb.put(count);                    // Place the generated value into the mailbox
      end
    endtask
  
    task p2;
      int count_get;
  
      // Try peeking values in the mailbox without consuming them
      repeat (15) begin
        mb.try_peek(count_get);           
        $display("Peeked count value: %0d", count_get);
      end
  
      // Now retrieve the values from the mailbox
      repeat (15) begin
        mb.get(count_get);            
        $display("Retrieved count value: %0d", count_get);
      end
    endtask
  
   
    initial begin
      fork
        p1(); 
        p2();
      join
    end
  
  endmodule
  