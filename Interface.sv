
// Interface for the AND module to group signals a, b, c, d, and y
interface and_inf();
    logic [3:0] a, b, c, d;      
    logic [3:0] y;               
  endinterface
  
  module tb;
  
    // Create an instance of the interface
    and_inf vif();
  
    // Explicit port mapping
    and_1 dut_explicit (
      .a(vif.a),                
      .b(vif.b),                 
      .c(vif.c),               
      .d(vif.d),              
      .y(vif.y)              
    );
    
    // Implicit port mapping
    
    // Uncomment the following line to use implicit port mapping
    // and_1 dut (vif.a, vif.b, vif.c, vif.d, vif.y);
    
  
    
    initial begin
  
      vif.a = 4'b0001;
      vif.b = 4'b0000;
      vif.c = 4'b1111;
      vif.d = 4'b1101;
  
      #1;  
      $display("At t=%0t: a=%b b=%b c=%b d=%b y=%b", $time, vif.a, vif.b, vif.c, vif.d, vif.y);
  
      vif.a = 4'b1111;
      vif.b = 4'b1111;
      vif.c = 4'b1010;
      vif.d = 4'b1010;
  
      #1; 
      $display("At t=%0t: a=%b b=%b c=%b d=%b y=%b", $time, vif.a, vif.b, vif.c, vif.d, vif.y);
  
      vif.a = 4'b0011;
      vif.b = 4'b0101;
      vif.c = 4'b1100;
      vif.d = 4'b0110;
  
      #2; 
      $display("At t=%0t: a=%b b=%b c=%b d=%b y=%b", $time, vif.a, vif.b, vif.c, vif.d, vif.y);
  
      $finish;
    end
  
    initial begin
      $dumpfile("dump.vcd");     
      $dumpvars(0, tb); 
    end
  
  endmodule
  