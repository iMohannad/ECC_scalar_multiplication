
module modular_adder #(parameter n = 231) (clk, reset, A, B,S);
  input [n-1: 0] A, B;
  input clk, reset;
  output reg [n-1:0] S;


  always @ (A or B) begin
    S = A + B;
  end


endmodule // modular_adder
