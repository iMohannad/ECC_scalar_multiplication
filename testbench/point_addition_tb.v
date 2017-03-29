`include "../src/point_addition.v"

module point_addition_tb ();

  parameter n = 10;
  reg [n-1:0] x1, x2, y1, y2;
  wire [n-1:0] x3, y3;
  reg clk;
  reg reset;
  wire flag;

  wire [n-1:0] p = 17;

  point_addition #(n) ptaddition (.clk(clk), .reset(reset), .p(p), .x1(x1),
        .y1(y1), .x2(x2), .y2(y2), .x3(x3), .y3(y3));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    x1 <= 6;
    y1 <= 3;
    x2 <= 5;
    y2 <= 1;
    #20

    $write("\nP = (%0d, %0d), Q = (%0d, %0d), P + Q = (%0d, %0d)\n",
          x1, y1, x2, y2, x3, y3);
    $display("time %0d", $time);

    #10
    $stop;
  end




endmodule // modular_multiplication_tb
