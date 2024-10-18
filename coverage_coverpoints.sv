/*
 * Problem Description:
 * Implement a SystemVerilog transaction class with covergroups to monitor specific 
 * address and data signals related to a hypothetical device. The requirements include:
 * - Coverpoints for transaction addresses with named bins.
 * - Transition bin for SPISSR to SPICR.
 * - Coverpoints on specific bits of the SPICR control register.
 * - Coverpoint for all 256 combinations of the first 8 bits of the SPIDTR register.
 * - Cross coverpoints between addresses and SPIDTR, as well as SPICR.
 */

 // File Description: SystemVerilog transaction class with covergroups
 // Date: 20 September 2024
 // Author: Ahmed Raza

 class transaction;
    rand bit [31:0] address; 
    rand bit [31:0] data;    
    bit write_i;            
  
    // Constraints to restrict the addresses
    constraint addr_constraint {
      address inside {32'h40, 32'h60, 32'h64, 32'h68, 32'h6C, 32'h70};
    }
    
    // Covergroup for monitoring addresses and data
    covergroup cg @ (address);
      option.per_instance = 1; // Separate instances for coverage
  
      // Coverpoint for addresses
      cp_addr: coverpoint address {
        bins SRR_addr   = {32'h40}; // System Register
        bins SPICR_addr = {32'h60}; // SPI Control Register
        bins SPISR_addr = {32'h64}; // SPI Status Register
        bins SPIDTR_addr = {32'h68}; // SPI Data Transfer Register
        bins SPIDRR_addr= {32'h6C}; // SPI Data Receive Register
        bins SPISSR_addr= {32'h70}; // SPI Slave Select Register
      }
  
      // Transition from SPISSR to SPICR
      cp_trans: coverpoint address {
        bins transition = (32'h70 => 32'h60);
      }
  
      // Coverpoints for SPICR (Control Register) on transaction data
      cp_SPICR_bits_4_3: coverpoint data[4:3] {
        bins CPOL_CPHA_00 = {2'b00}; // CPOL = 0, CPHA = 0
        bins CPOL_CPHA_01 = {2'b01}; // CPOL = 0, CPHA = 1
        bins CPOL_CPHA_10 = {2'b10}; // CPOL = 1, CPHA = 0
        bins CPOL_CPHA_11 = {2'b11}; // CPOL = 1, CPHA = 1
      }
  
      cp_SPICR_bit_9: coverpoint data[9] {
        bins master_inhibit_0 = {1'b0}; // Inhibit disabled
        bins master_inhibit_1 = {1'b1}; // Inhibit enabled
      }
  
      cp_SPICR_bit_0: coverpoint data[0] {
        bins spi_enable_0 = {1'b0}; // SPI disabled
        bins spi_enable_1 = {1'b1}; // SPI enabled
      }
  
      // Coverpoint for SPIDTR register (first 8 bits)
      cp_spidtr_data: coverpoint data[7:0] {
        bins spidtrt_all_combinations[] = { [0:255] }; // Covers all 256 values
      }
  
      // Cross coverpoint between addresses and SPIDTR data
      cp_cross: cross cp_addr, cp_spidtr_data {
        ignore_bins non_spidtr_addr = binsof(cp_addr) intersect { 
          {32'h40}, {32'h60}, {32'h64}, {32'h6C}, {32'h70}
        }; // Ignore non-SPIDTR addresses
      }
  
      // Cross coverpoint for SPICR addresses and data
      cp_cross_spicr: cross cp_addr, cp_SPICR_bits_4_3, cp_SPICR_bit_9, cp_SPICR_bit_0 {
        // Create cross bins for SPICR address (0x60)
      
  //        option.auto_bin_max = 0;         Commented it because this option does not work in Aldec Simulator
        
        bins cross_SPICR_CPOL_CPHA_00 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bits_4_3) intersect {2'b00};
        bins cross_SPICR_CPOL_CPHA_01 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bits_4_3) intersect {2'b01};
        bins cross_SPICR_CPOL_CPHA_10 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bits_4_3) intersect {2'b10};
        bins cross_SPICR_CPOL_CPHA_11 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bits_4_3) intersect {2'b11};
  
        bins cross_SPICR_master_inhibit_0 = binsof(cp_addr) intersect {32'h60} &&
                                            binsof(cp_SPICR_bit_9) intersect {1'b0};
        bins cross_SPICR_master_inhibit_1 = binsof(cp_addr) intersect {32'h60} &&
                                            binsof(cp_SPICR_bit_9) intersect {1'b1};
  
        bins cross_SPICR_spi_enable_0 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bit_0) intersect {1'b0};
        bins cross_SPICR_spi_enable_1 = binsof(cp_addr) intersect {32'h60} &&
                                        binsof(cp_SPICR_bit_0) intersect {1'b1};
      }
    endgroup
  
    // Constructor
    function new();
      cg = new(); // Instantiate the covergroup
    endfunction
  endclass
  
  // Testbench
  module tb_transaction;
  
    initial begin
      // Instantiate the transaction class
      transaction t = new();
  
      // Randomly sample the covergroup
      repeat (500) begin
        if (t.randomize()) begin
          t.cg.sample(); // Sample the covergroup
          $display("Address: 0x%h, Data: 0x%h", t.address, t.data);
        end
      end
  
      // End simulation
      $finish;
    end
  
  endmodule
  