

// Input: P = k(x1, y1), k
// Output: kP = (x3, y3)
module double_and_add #(parameter n = 231) (clk, reset, p, k, x1, y1, a, x3, y3, mult_result);
  input clk, reset;
  input [n-1:0] p, x1, y1, a, k;
  output reg [n-1:0] x3, y3;
  output infinity;
  output reg result;

  wire result_double, result_add, infinity_double, infinity_add;

  point_doubling #(231)  (.clk(clk), .reset(reset), .p(p), .x1(x1),
        .y1(y1), .a(a), .x3(x3), .y3(y3), .result(result_double), .infinity(infinity_double));

  assign x1 = (result) ? x3 : x1;
  assign y1 = (result) ? y3 : y1;

  point_addition #(231) (.clk(clk), .reset(reset), .p(p), .x1(x1),
        .y1(y1), .x2(x2), .y2(y2), .x3(x3), .y3(y3), .result(result_add), .infinity(infinity_add));


endmodule // double_and_add
