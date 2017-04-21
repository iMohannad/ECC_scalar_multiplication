
module modular_multiplier #(parameter n = 231) (clk, reset, A, B, M, p, flag);
  input [n-1:0] A, B, p;
  input clk, reset;
  output reg [n-1:0] M;
  output reg flag;  //flag signal to determine when the multiplier has finished.



  //Temp values that will be used in the algorithm
  reg [n-1:0] T;

  reg [n-1:0] counter = 0;

  always @ (posedge clk) begin
    if (reset) begin
      M <= 0;
      T <= 0;
      flag <= 0;

      counter <= 0;
    end
    else begin
      if(flag != 1) begin
        //First Iteration, initalize the values T and M
        if (counter == 0) begin
          T = A;
          M = 0;
        end
        //Check if Bi = 1,Add temp value to M mod p
        if (B[counter] == 1) begin
          M = (M + T) % p;
        end
        //Always double T mod p
        T = (2 * T) % p;
        counter = counter + 1;
        //if the last bit has been reached. Raise the flag.
        if (counter == (n)) begin
          flag = 1;
        end
      end
    end
  end

endmodule // modular_multiplier
