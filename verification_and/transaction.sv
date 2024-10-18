// Transaction Class
class Transaction;
    randc bit A, B, C, D;  // Four inputs for AND gate
    bit Y;                 // Output result
  
    function Transaction copy();
      Transaction t_copy = new();
      t_copy.A = this.A;
      t_copy.B = this.B;
      t_copy.C = this.C;
      t_copy.D = this.D;
      t_copy.Y = this.Y;
      return t_copy;
    endfunction
  endclass