module mailbox_ex;
    mailbox#(string) mail = new(); //Unbunded
    initial begin
      mail.put("Hello");
      #5;
      mail.put("World");
    end
    
    
    initial begin 
      string message1, message2;
      mail.get(message1);
      $display("Message 1 is given at time %0t is:", $time, message1);
    
    
    #5;
    mail.peek(message2);
    $display("Message 2 is given at time %0t is:", $time, message2);
    
      end
    
  endmodule
  