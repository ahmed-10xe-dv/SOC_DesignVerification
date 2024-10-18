interface risc_spm_if #(parameter ADDRESS_WIDTH = 8) (input bit clk);
    bit rst;
    bit [ADDRESS_WIDTH-1:0] data_out;
    logic [ADDRESS_WIDTH-1:0] address;
    logic [ADDRESS_WIDTH-1:0] data_in;
    logic write;
  
    modport DUT (input clk, data_out, 
                 output address, data_in, write);
endinterface
