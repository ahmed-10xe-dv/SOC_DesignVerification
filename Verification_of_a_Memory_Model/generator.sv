/*
Generator Class is responsible for :
    1. Generating the stimulus by randomizing the transaction class
    2. Sending Randomized transaction to the driver using Mailbox


*/

class generator;
    

  rand Transaction tr;                       //Daclaring the transaction random
  mailbox mbx_G2D;                           // Declaring the Mailbox for communication b/w Generator and Driver
  int repeat_count;                          // To control the number of transactions being generated
  event completion;                          // Event to indicate that one transaction has been generated and putted on mailbox successfully


  function new(mailbox mbx_G2D, event completion);                   // Will get this mailbox and event  handle from the environment
      this.mbx_G2D = mbx_G2D; 
      this.completion = completion;                    //Connecting the mailbox of generator to enriveronment mailbox handle
      tr = new();                                 // Creating instance here to make use of blueprint Method        
  endfunction //new()



  //Controls the number of transactions generated
task main();
repeat(repeat_count) begin    
  if (!tr.randomize()) begin
    $fatal("[Gen] :: Transaction Randomization Failed!"); // Generates fatal error if randomization fails
  end
  mbx_G2D.put(tr.copy()); // Putting the transaction copy into the mailbox
  -> completion;          // Trigger the completion event
end
endtask // main



endclass //generator