// Author: Ahmed Raza
// Date: September 19, 2024
// Description: This SystemVerilog code demonstrates the use of randomization and mailbox-based communication 
// between classes. A 'transaction' class with 'addr' and 'data' properties is randomized inside the 'generator' class.
// The randomized data is sent via a mailbox and retrieved by the 'driver' class to display in the console.

class mail_box;
    mailbox mail = new(20); // Initialize a mailbox with a depth of 20
  endclass
  
  
  class transaction;
    rand bit [7:0] addr; // Randomizable address (8-bit)
    rand int data;       // Randomizable data (32-bit)
  endclass
  
  
  
  class generator;
    // Randomizes the transaction's properties
    task rand_func(transaction tr);
      tr.randomize(); 
    endtask
    
    // Sends the randomized data to the mailbox
    task put_meth(transaction tr, mail_box m1);
      m1.mail.put(tr.addr);
      m1.mail.put(tr.data);
    endtask
  endclass
  
  
  class driver;
    int rand_data;
    bit [7:0] rand_addr;
    
    // Retrieves the data from the mailbox and displays it
    task display(mail_box m1);
      m1.mail.get(rand_data);
      m1.mail.get(rand_addr);
      
      $display("@%0t the data is :: %0d \t and the address is :: 0x%0h", $time, rand_data, rand_addr); 
      #5;
    endtask
  endclass
  
  
  module tb;
    mail_box m1 = new(); // Create mailbox instance
    initial begin
      fork
      repeat(10) begin
        transaction tr = new();    // Transaction instance
        generator gen = new();     // Generator instance
        driver drv = new();        // Driver instance
        
        gen.rand_func(tr);         // Randomize transaction
        gen.put_meth(tr, m1);      // Put data in mailbox
        drv.display(m1);           // Display the data retrieved from mailbox
      end
      join
      $display("@%0t Process has been finished sucessfully", $time); 
      
    end
  endmodule
  