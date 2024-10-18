//Author: Ahmed Raza
// Use of try_peak() 

module mailbox_example();
  
    mailbox mb = new ();
    
    task p1;
      int count;
      repeat (10) begin
        count = $urandom_range(1, 100 );
        mb.put(count);
        $display ("Put random count value:: %0d", count);
      end
      $display("All Items Put complete");
    endtask
    
    task p2;
      int count_get;
      repeat (10) begin
        mb.try_peek(count_get);
        $display ("Get count value:: %0d", count_get);
      end 
      $display("Get all values succeeded");
    endtask
    
    initial begin
      
      fork
        p1();
        p2();
      join
      
    end
    
  endmodule