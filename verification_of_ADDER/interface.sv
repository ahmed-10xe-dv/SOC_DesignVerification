// Interface to connect to DUT
interface AdderInterface();
  logic clk;
  logic rst;
  logic [4:0] in1, in2;
  logic valid_in;
  logic [5:0] out;
  logic valid_out;
endinterface
