module AND1(input logic  A, B, C, D,
    output logic Y);
logic Y1, Y2;

assign Y1 = A & B;
assign Y2 = C & D;
assign Y = Y1 & Y2;

endmodule 