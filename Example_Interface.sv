//Notes on Interfaces 





//A simple interface
interface simple_bus;
    logic req, gnt;
    logic [7:0] addr, data;
    
    logic [1:0] mode;
    logic start, rdy;
    
  endinterface
  
  
  
  
  //Here we are using different names of the interfaces in the arguments of the module i.e a and b
  module memMod( simple_bus a, input bit clk);
    logic avail;
    ...
  endmodule 
  
  module cpuMOD( simple_bus b, input bit clk);
    ..
  endmodule
  
  module top;
    
    logic clk = 0;
    simple_bus sb_intf();
    memMOD mem(sb_intf, clk);
    cpuMOD cpu(.b(sb_intf), .clk(clk));
  endmodule
  
  // we can use the implicit port connections if we chosse the same names for the interfaces here it is given 
  
  
  module memmMOD( simple_bus sb_intf, input bit clk);
    ...
  endmodule
  
  module cpuMOD(simple_bus sb_intf, input bit clk);
    ...
  endmodule 
  
  
  
  module tb;
    
    logic clk =0;
    simple_bus sb_intf();
    memMOD mem(.*);
    cpuMOD cpu(.*);   //Implicit port connections
  endmodule
  
    
    
  endmodule
  
    