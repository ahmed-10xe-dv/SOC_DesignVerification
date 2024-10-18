// Author: Ahmed Raza
// Date: 9 September 2024
// Description: This module demonstrates typedef usage for 16-bit data bus 
// and an enum for conditional branch types with display statements.

module typedef_enum;

    // Define a 16-bit wide enum typedef for data_bus_t
    typedef logic [15:0] data_bus_t;
    data_bus_t data;
  
    // Enum typedef for branch conditions (br_cond_e)
    typedef enum logic [2:0] {
      BEQ, BNE, NO_CONDITION, BLT, BGE = 3'b101, BLTU, BGEU
    } br_cond_e;
  
    // Declare a variable of type br_cond_e
    br_cond_e branches;
  
    // Declare an array for all possible branch conditions
    br_cond_e all_branches[7] = '{BEQ, BNE, NO_CONDITION, BLT, BGE, BLTU, BGEU};
  
    // Initial block for displaying enum values using case statement
    initial begin
      foreach (all_branches[i]) begin
        branches = all_branches[i];
        case (branches)
          BEQ: $display("Branch: BEQ, Binary: %b", branches);
          BNE: $display("Branch: BNE, Binary: %b", branches);
          NO_CONDITION: $display("Branch: NO_CONDITION, Binary: %b", branches);
          BLT: $display("Branch: BLT, Binary: %b", branches);
          BGE: $display("Branch: BGE, Binary: %b", branches);
          BLTU: $display("Branch: BLTU, Binary: %b", branches);
          BGEU: $display("Branch: BGEU, Binary: %b", branches);
          default: $display("Unknown branch condition");
        endcase
      end
    end
  endmodule
  