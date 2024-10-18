class Driver;
    virtual mem_int v_mem_int;
    
    function new(input inst_mbox #(Instruction) agt2drv, input mem_int v_mem_int);
      this.agt2drv = agt2drv;
      this.v_mem_int = v_mem_int;
    endfunction
  endclass
  
  class Environment;
    Driver drv;
    ...
    drv = new(agt2drv, v_mem_int);
    ...
  endclass
  