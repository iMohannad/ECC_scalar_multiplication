`include "../src/multiplicative_inverse.v"

module multiplicative_inverse_tb ();

  parameter n = 200; //needs to be 1-2 bit larger than the number of bit in the prime number
  reg [n-1:0] A;
  reg [n-1:0] p;
  wire [n-1:0] X;
  reg clk;
  reg reset;
  wire result_ready;



  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .p(p), .A(A), .X(X), .result_ready(result_ready));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    p <= 64'd6277101735386680763835789423207666416083908700390324961279;
    A <= 64'h188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012;
    #10
    wait(result_ready == 1);
    #10

    $write("\nA = %0d, p = %0d, A^{-1} = %0d\n", A, p, X);
    $display("time %0d", $time);

    #10
    $stop;
  end




endmodule // modular_multiplication_tb
