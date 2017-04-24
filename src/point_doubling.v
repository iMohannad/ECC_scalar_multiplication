

// Input: P = (x1, y1),
// Output: P + Q = (x3, y3)
module point_doubling #(parameter n = 231) (clk, reset, p, x1, y1, a, x3, y3, result, infinity);
  input clk, reset;
  input [n-1:0] p, x1, y1, a;
  output reg [n-1:0] x3, y3;
  output infinity;
  output reg result;
  wire [n-1:0] lambda;
  wire [n-1:0] x1x3_diff;
  wire [n-1:0] denominator;   //denominator of lambda
  wire [n-1:0] numerator;     //numerator of lambda
  wire result_ready;          //to check if the modular inverse is ready
  reg enable; //to reset multiplicative inverse
  wire [n-1:0] denominator_inv, x1x1, lambda2;

  //compute the numerator 3x1^2 + a
  assign numerator = ((3*x1*x1) + a) % p;
  //compute the denominator 2y
  assign denominator = (2*y1) % p;

  //find the negative of y1 to check if the result is infinity.
  //The result is infinity if x1 = x2, and y1 = -y2
  wire [n-1:0] neg_y = (-y1 < 0) ? -y1 + p : -y1;

  //it needs to be multiplied by the inverse.
  assign lambda = (result_ready) ? (numerator * denominator_inv) % p : lambda;
  assign x1x1 = (x1 + x1)  % p;
  assign lambda2 = (lambda * lambda) % p; //lambda^2
  assign x1x3_diff = (x1 >= x3) ? (x1 - x3) : (x1 + p - x3);
  assign infinity = (y1 == -y1) ? 1 : 0; //The result is infinity if y1 == -y1

  multiplicative_inverse #(n) multi_inv (.clk(clk), .reset(reset), .enable(enable), .p(p), .A(denominator), .X(denominator_inv), .result_ready(result_ready));

  reg flagx3;

  always @ (posedge clk) begin
    if (reset) begin
      x3 <= x1;
      flagx3 <= 0;
      result <= 0;
    end
    else begin
      if (enable) enable <= 0;
      //Check if y1 == -y1, then the point is infinity
      if (infinity) begin
        x3 = 'hz;
        y3 = 'hz;
      end
      else begin
        //only assign the results once the modular_inverse is ready
        if (result_ready) begin
          if(lambda2 < x1x1) x3 = (lambda2 + p - x1x1) % p;
          else x3 = (lambda2 - x1x1) % p;
          flagx3 <= 1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      y3 <= y1;
    end
    else begin
      if (result) begin
        result <= 0;
        flagx3 <= 0;
        enable <= 1;
      end
      else if(flagx3) begin
        y3 <= (lambda * x1x3_diff - y1 + p) % p;
        result <= 1;
      end
    end
  end


endmodule // point_doubling
