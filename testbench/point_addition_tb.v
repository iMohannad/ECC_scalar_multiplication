`include "../src/point_addition.v"

module point_addition_tb ();

  parameter n = 300;
  reg [n-1:0] x1, x2, y1, y2;
  wire [n-1:0] x3, y3;
  reg clk;
  reg reset;
  wire result_ready, infinity;

  wire [n-1:0] p = 192'hfffffffffffffffffffffffffffffffeffffffffffffffff;

  point_addition #(n) ptaddition (.clk(clk), .reset(reset), .p(p), .x1(x1),
        .y1(y1), .x2(x2), .y2(y2), .x3(x3), .y3(y3), .result(result_ready), .infinity(infinity));

  initial begin
    clk = 1; forever #5 clk = ~clk;
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    x1 <= 192'hd458e7d127ae671b0c330266d246769353a012073e97acf8;
    y1 <= 192'h325930500d851f336bddc050cf7fb11b5673a1645086df3b;
    x2 <= 192'hf22c4395213e9ebe67ddecdd87fdbd01be16fb059b9753a4;
    y2 <= 192'h264424096af2b3597796db48f8dfb41fa9cecc97691a9c79;
    #10
    wait(result_ready == 1 | infinity == 1);
    #20 //I have to wait at least one cycle in order for the results to be shown in the registers.
    $write("\nP = (%0h, %0h), Q = (%0h, %0h), P + Q = (%0h, %0h)\n",
          x1, y1, x2, y2, x3, y3);
    $display("time %0d", $time);




    $stop;
  end




endmodule // modular_multiplication_tb
