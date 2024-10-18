/*
  Author: Ahmed Raza
  Date: September 19, 2024
  
  Description:
  This SystemVerilog program implements a bounded mailbox with a size of 3.
  The program has two processes: 
  - Process1 randomly generates 5 values and attempts to put them into the mailbox using `try_put`. 
    If the values are added successfully, it displays the values. Otherwise, it shows the current number of values in the mailbox.
  - Process2 tries to retrieve 5 values using `try_get`. If successful, it displays the retrieved values; 
    otherwise, it shows how many values remain in the mailbox.

  The program uses the `fork-join` construct to run both processes concurrently.
*/

module bound_mail;

    mailbox mail = new(3); // Bounded mailbox with size 3
    int val; 
    
    // Process1: Puts values in the mailbox
    task Process1;
      repeat(5) begin
        val = $urandom_range(0, 100); // Randomly generate a value between 0 and 100
        if (mail.try_put(val)) begin
          $display("Value successfully added: %0d", val);
        end else begin 
          $display("Mailbox is full. Currently, the number of values in mailbox: %0d", mail.num());
        end
      end
    endtask
                     
    // Process2: Retrieves values from the mailbox
    task Process2;
      repeat(5) begin
        int val_new;
        if (mail.try_get(val_new)) begin
          $display("Value successfully retrieved: %0d", val_new);
        end else begin 
          $display("Mailbox is empty. Number of values currently in mailbox: %0d", mail.num());
        end
      end
    endtask
  
    initial begin
      fork
        Process1(); 
        Process2();
      join
    end
  endmodule
  