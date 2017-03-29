

// Input: P = (x1, y1), Q = (x2, y2).
// Output: P + Q = (x3, y3)
module point_addition #(parameter n = 231) (clk, reset, p, x1, y1, x2, y2, x3, y3);
  input clk, reset;
  input [n-1:0] p, x1, y1, x2, y2;
  output reg [n-1:0] x3, y3;

  wire [n-1:0] lambda;
  wire [n-1:0] y_diff;
  wire [n-1:0] x_diff;
  assign y_diff = y2 - y1;
  assign x_diff = x2 - x1;

  //it needs to be multiplied by the inverse.
  assign lambda = y_diff / x_diff;

  always @ (posedge clk) begin
    if (reset) begin
      x3 = 0;
      y3 = 0;
    end
    else begin
      x3 = ((lambda * lambda) + x1 + x2) % p;
      y3 = (lambda * (x1 - x3) - y1) % p;
    end
  end


endmodule // point_addition
