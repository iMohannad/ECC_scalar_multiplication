

// Input: P = (x1, y1), Q = (x2, y2).
// Output: P + Q = (x3, y3)
module point_addition #(parameter n = 231) (clk, reset, p, x1, y1, x2, y2, x3, y3, result_ready);
  input clk, reset;
  input [n-1:0] p, x1, y1, x2, y2;
  output reg [n-1:0] x3, y3;
  output result_ready;
  wire [n-1:0] lambda;
  wire [n-1:0] y_diff;
  wire [n-1:0] x_diff;
  wire [n-1:0] x1x3_diff;
  assign y_diff = (y2 >= y1) ? y2 - y1 : (y2-y1)+p;
  assign x_diff = (x2 >= x1) ? x2 - x1 : (x2 - x1) + p;

  wire [n-1:0] x_diff_inv, x1x2, lambda2;



  //it needs to be multiplied by the inverse.
  assign lambda = (result_ready) ? (y_diff * x_diff_inv) % p : 1'hz;
  assign x1x2 = x1 + x2;
  assign lambda2 = (lambda * lambda) % p;
  assign x1x3_diff = (x1 >= x3) ? (x1 - x3) : (x1 + p - x3);
  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .p(p), .A(x_diff), .X(x_diff_inv), .result_ready(result_ready));

  always @ (posedge clk) begin
    if (reset) begin
      x3 = 0;
      y3 = 0;
    end
    else begin
      if (result_ready) begin
        if(lambda2 < x1x2) x3 = (lambda2 + p - x1x2) % p;
        else x3 = (lambda2 - x1x2) % p;
        y3 = (lambda * x1x3_diff - y1) % p;
      end

    end
  end


endmodule // point_addition
