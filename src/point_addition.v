

// Input: P = (x1, y1), Q = (x2, y2).
// Output: P + Q = (x3, y3)
module point_addition #(parameter n = 231) (clk, reset, p, x1, y1, x2, y2, x3, y3, result, infinity);
  input clk, reset;
  input [n-1:0] p, x1, y1, x2, y2;
  output reg [n-1:0] x3, y3;
  output infinity;
  output reg result;
  wire [n-1:0] lambda;
  wire [n-1:0] y_diff;
  wire [n-1:0] x_diff;
  wire [n-1:0] x1x3_diff;
  wire result_ready;
  assign y_diff = (y2 >= y1) ? y2 - y1 : (y2-y1)+p;
  assign x_diff = (x2 >= x1) ? x2 - x1 : (x2 - x1) + p;

  wire [n-1:0] x_diff_inv, x1x2, lambda2;

  //find the negative of y1 to check if the result is infinity.
  //The result is infinity if x1 = x2, and y1 = -y2
  wire [n-1:0] neg_y = (-y1 < 0) ? -y1 + p : -y1;

  //it needs to be multiplied by the inverse.
  assign lambda = (result_ready) ? (y_diff * x_diff_inv) % p : 1'hz;
  assign x1x2 = x1 + x2;
  assign lambda2 = (lambda * lambda) % p;
  assign x1x3_diff = (x1 >= x3) ? (x1 - x3) : (x1 + p - x3);
  assign infinity = (x_diff == 0) ? 1 : 0; //The result is infinity if x_diff is 0

  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .p(p), .A(x_diff), .X(x_diff_inv), .result_ready(result_ready));

  reg x3_ready;

  always @ (posedge clk) begin
    if (reset) begin
      x3 = 0;
    end
    else begin
      if (result) result <= 0;
      //Check if xdiff = 0, then the point is infinity
      if (infinity) begin
        x3 = 'hz;
        y3 = 'hz;
      end
      else begin
        //only assign the results once the modular_inverse is ready
        if (result_ready) begin
          if(lambda2 < x1x2) x3 <= (lambda2 + p - x1x2) % p;
          else x3 <= (lambda2 - x1x2) % p;
          x3_ready <= 1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      y3 = 0;
    end
    else begin
      if(result_ready && x3_ready) begin
        y3 <= (lambda * x1x3_diff - y1 + p) % p;
        result <= 1;
      end
    end
  end


endmodule // point_addition
