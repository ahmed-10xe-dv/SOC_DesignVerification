`include "interface.sv"
// `include "random_test.sv"
// `include "default_rd_test.sv"
// `include "wr_rd_test.sv"
`include "RW_SameAddr.sv"
// `include "RW_DiffAddr.sv"
// `include "reset_test.sv"



module tb_top ;

  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
    
    
  end

  mem_intf intf(clk,reset);

    
    //DUT instance, interface signals are connected to the DUT ports
    memory DUT (
        .clk(intf.clk),
        .reset(intf.reset),
        .addr(intf.addr),
        .wr_en(intf.wr_en),
        .rd_en(intf.rd_en),
        .wdata(intf.wdata),
        .rdata(intf.rdata)
       );

       test t1(intf);


       initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
      end
endmodule