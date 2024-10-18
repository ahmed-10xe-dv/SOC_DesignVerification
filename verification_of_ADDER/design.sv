module adder (clock, reset, in1, in2, valid_in, out, valid_out);
  input clock, reset;
  input [4:0] in1, in2;
  input valid_in;
  output reg [5:0] out;
  output reg valid_out;

  always @(posedge clock) begin
    if (reset) begin 
      out <= 6'b0;
      valid_out <= 0;
    end
    else begin
      out <= in1 + in2;
      valid_out <= valid_in;
    end
  end

endmodule: adder