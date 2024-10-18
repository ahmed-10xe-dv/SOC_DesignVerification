
/* This Transaction class id responsible for
1. Declare Fields required to generate Stimulus
2. Can also be used for placeholder for the activity monitored in the MONITOR
3. 

*/

class Transaction;

  //Transaction Fields
 rand bit [1:0] addr;
 rand bit       wr_en;
 rand bit       rd_en;
 rand bit [7:0] wdata;

  bit [7:0] rdata;
  bit [1:0] cnt;

  //Constraints
constraint wr_rd_c { wr_en != rd_en;};                   //Can't Read and Write at the same time




  //A copy function to use for the blueprint method in randomization
  function Transaction copy();
      Transaction tr_copy = new();

      tr_copy.addr = this.addr;
      tr_copy.wr_en = this.wr_en;
      tr_copy.rd_en = this.rd_en;
      tr_copy.wdata = this.wdata;
      tr_copy.rdata = this.rdata;
      tr_copy.cnt = this.cnt;

      return tr_copy;
  endfunction



  // function new();
      
  // endfunction //new()
endclass //Transaction
