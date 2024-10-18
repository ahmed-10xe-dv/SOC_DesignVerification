// Transaction Class
class Transaction;
  randc bit [4:0] in1;
  randc bit [4:0] in2;
  bit rst, valid_out, valid_in;
  bit [5:0] out;          

  function Transaction copy();  
    Transaction t_copy = new();
    
    t_copy.rst = this.rst;
    t_copy.in1 = this.in1;
    t_copy.in2= this.in2;
    t_copy.valid_in = this.valid_in;
    t_copy.out = this.out;
    t_copy.valid_out = this.valid_out;
    
    return t_copy;
  endfunction
endclass