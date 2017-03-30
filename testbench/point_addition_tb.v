`include "../src/point_addition.v"

module point_addition_tb ();

  parameter n = 10;
  reg [n-1:0] x1, x2, y1, y2;
  wire [n-1:0] x3, y3;
  reg clk;
  reg reset;
  wire result_ready, infinity;

  wire [n-1:0] p = 17;

  point_addition #(n) ptaddition (.clk(clk), .reset(reset), .p(p), .x1(x1),
        .y1(y1), .x2(x2), .y2(y2), .x3(x3), .y3(y3), .result_ready(result_ready), .infinity(infinity));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    x1 <= 5;
    y1 <= 16;
    x2 <= 5;
    y2 <= 1;
    #10
    wait(result_ready == 1 | infinity == 1);
    if (result_ready == 1) begin
      #30
      $write("\nP = (%0d, %0d), Q = (%0d, %0d), P + Q = (%0d, %0d)\n",
            x1, y1, x2, y2, x3, y3);
      $display("time %0d", $time);
    end



    $stop;
  end




endmodule // modular_multiplication_tb
