program automatic test;
    mailbox #(int) mbx;
    int value;
    initial begin
      mbx = new(1);
      $display(" Num %0d try get %0d", mbx.num, mbx.try_get(value));
      mbx.put(2);
      $display(" Num %0d try put %0d", mbx.num, mbx.try_put(value));
      mbx.peek(value);
      $display(" Val %0d ", value);
    end
  endprogram