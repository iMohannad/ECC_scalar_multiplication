
module modular_multiplier #(parameter n = 231) (clk, reset, A, B, M);
  input [n-1:0] A, B;
  input clk, reset;
  output reg [n-1:0] M;

  //flag signal to determine when the multiplier has finished.
  wire flag = 0;

  //Temp values that will be used in the algorithm
  reg [n-1:0] P;

  int counter = 0;

  always @ (posedge clk) begin
    if (reset) begin
      A <= 0;
      B <= 0;
      counter <= 0;
    end
    else begin
      //First Iteration, initalize the values P and M
      if (counter == 0) begin
        P <= A;
        M <= 0;
      end
      else if (counter == (n-1)) begin
        flag <= 1;
        break;
      end
      //Check if Bi = 1, modify M.
      if (B[counter] == 1) begin
        M <= (M + P);
      end
      //Always double P
      P <= 2 * P;
      counter <= counter + 1;
    end

  end

endmodule // modular_multiplier
