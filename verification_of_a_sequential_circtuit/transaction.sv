// Transaction Class
class Transaction;
  randc bit [7:0] loadin;  
  bit rst, up, load;
  bit [7:0] y;          

  function Transaction copy();    //Making a copy method to use in blueprint method for better approach
    Transaction t_copy = new();
    t_copy.loadin = this.loadin;
    t_copy.rst = this.rst;
    t_copy.up = this.up;
    t_copy.load = this.load;
    t_copy.y = this.y;
    
    return t_copy;
  endfunction
endclass