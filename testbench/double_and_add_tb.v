`include "../src/double_and_add.v"

module double_and_add_tb ();

  parameter n = 420;
  reg [n-1:0] x1, y1;
  wire [n-1:0] x3, y3;
  reg clk, reset;
  reg [n-1:0] a, c;

  wire done;

  reg [n-1:0] p;

  double_and_add #(n) doubleandadd (.clk(clk), .reset(reset), .p(p), .c(c), .x1(x1), .y1(y1), .a(a), .x3(x3), .y3(y3), .done(done));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    c <= 192'ha78a236d60baec0c5dd41b33a542463a8255391af64c74ee;
    #20 reset <= 0;
    p <= 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;
    //Adding point P = (x1, y1)
    x1 <= 192'hd458e7d127ae671b0c330266d246769353a012073e97acf8;
    y1 <= 192'h325930500d851f336bddc050cf7fb11b5673a1645086df3b;
    //Depends on the elliptic curve function Y^2 = X^3 + bX + a
    a <= 192'hfffffffffffffffffffffffffffffffefffffffffffffffc;
    //c <= 4;

    #10
    //checks if the result is ready, or the point is infinity.
    wait(done == 1);
    #20 //I have to wait at least one cycle in order for the results to be shown in the registers.
    $write("\nP = (%0h, %0h), kP = (%h, %h)\n",
          x1, y1, x3, y3);
    $display("time %0d", $time);





    $stop;
  end




endmodule // modular_multiplication_tb
