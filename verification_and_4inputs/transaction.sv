// Transaction Class
class Transaction;
  randc bit [3:0] input_a, input_b;  // Inputs for AND gate
  bit [3:0] result;                 // Output result

  function Transaction copy();
    Transaction t_copy = new();
    t_copy.input_a = this.input_a;
    t_copy.input_b = this.input_b;
    t_copy.result = this.result;
    return t_copy;
  endfunction
endclass